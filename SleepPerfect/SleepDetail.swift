//
//  SleepDetail.swift
//  SleepPerfect
//
//  Created by Michael Nath on 5/8/21.
//

import SwiftUI

struct SleepDetail: View {
    var body: some View {
        VStack {
            Text("Sleep Duration: {SLEEP_HOURS}")
            HStack {
                Text("Start Time: {SLEEP_START}")
                Text("End Time: {SLEEP_END}")
            }
        }
    }
}

struct SleepDetail_Previews: PreviewProvider {
    static var previews: some View {
        SleepDetail()
            .preferredColorScheme(.dark)
    }
}
