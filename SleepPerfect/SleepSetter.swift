import SwiftUI
import CoreData

struct SleepSetter: View {
    @State private var isSleeping : Bool = false // State var to manage start/end of sleep session
    @State private var isShowingSleepWarning : Bool = false // State var to manage action sheet
    @State private var sleepStart: Date = Date()
    @State private var sleepEnd: Date = Date()
    @Environment(\.managedObjectContext) private var viewContext // Retreieve app managed object context to add created sleep logs
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // timer will update the elapsed time every second
    let persistenceController = PersistenceController.shared
    
    func handleSleep() {
        isSleeping.toggle()
        if (isSleeping) {
            sleepStart = Date()
            sleepEnd = Date()
        } else {
            addSleep(sleepStart: sleepStart, sleepEnd: sleepEnd, date: Date())
        }
    }
    var body: some View {
        VStack {
            Text("Started Sleeping at: \(stringify(date: sleepStart))")
            Text(!isSleeping ? "Stopped Sleeping at \(stringify(date: sleepEnd))" : "")
            Text("Elapsed Time: \(format(duration: sleepEnd.timeIntervalSince(sleepStart)))").onReceive(timer) {
                _ in if (isSleeping) {
                    sleepEnd = Date()
                }
            }
            if (!isSleeping) {
                Toggle(isOn: $isShowingSleepWarning) {
                    Text("Track Sleep Mode")
                }.actionSheet(isPresented: $isShowingSleepWarning, content: {
                    ActionSheet(
                        title: Text("You Sure?"),
                        message: Text("If you continue, the app will record now as the start time"),
                        buttons: [
                            .cancel(),
                            .default(
                                Text("I am going to sleep!"),
                                action: handleSleep
                            )
                        ]
                    )
                })
            }
            else {
                Toggle(isOn: $isShowingSleepWarning) {
                    Text("Stop Recording Sleep Session" )
                }.alert(isPresented: $isShowingSleepWarning) {
                    Alert(
                        title: Text("Sleep Saved!"),
                        message: Text("This sleep session has been automatically saved."),
                        dismissButton: .default(Text("Thanks!")) {
                            handleSleep()
                        }
                    )
                }
            }
        }
    }
    
    private func addSleep(sleepStart: Date, sleepEnd: Date, date: Date) {
        withAnimation {
            let newSleep = Sleep(context: viewContext)
            newSleep.startTime = sleepStart
            newSleep.endTime = sleepEnd
            newSleep.date = date
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SleepSetter_Previews: PreviewProvider {
    static var previews: some View {
        SleepSetter().preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
