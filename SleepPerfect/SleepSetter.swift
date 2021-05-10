import SwiftUI
import CoreData

struct SleepSetter: View {
    @State private var isSleeping : Bool = false
    @State private var isShowingSleepWarning : Bool = false
    @State private var sleepStart: Date = Date()
    @State private var sleepEnd: Date = Date()
    @Environment(\.managedObjectContext) private var viewContext
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                }.onChange(of: isShowingSleepWarning) {
                    _ in
                        handleSleep()
                        isShowingSleepWarning.toggle()
                }
            }
        }
    }
    
    private func addSleep(sleepStart: Date, sleepEnd: Date, date: Date) {
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

struct SleepSetter_Previews: PreviewProvider {
    static var previews: some View {
        SleepSetter()
    }
}
