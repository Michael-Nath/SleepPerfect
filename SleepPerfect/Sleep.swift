//
//  Sleep.swift
//  SleepPerfect
//
//  Created by Michael Nath on 5/8/21.
//

import Foundation

func format(duration: TimeInterval) -> String {
    let formatter = DateComponentsFormatter() // set up formatter obj
    formatter.allowedUnits = [.hour, .minute, .second] // humans sleep less for than a day
    formatter.unitsStyle = .full // e.g. “9 hours, 41 minutes, 30 seconds”
    if let formattedTime = formatter.string(from: duration) {
        return formattedTime
    } else {
        return ""
    }
}

func stringify(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY, MMM d, hh:mm"
    return dateFormatter.string(from: date)
}

//struct Sleep {
//    var startTime: Date
//    var endTime: Date
//    var duration: String {
//        format(duration: endTime.timeIntervalSince(startTime))
//    }
//}
