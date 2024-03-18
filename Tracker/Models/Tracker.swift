//
//  Tracker.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 25.01.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let timetable: Schedule?
}

extension Tracker {
    struct Track {
        var name: String = ""
        var color: UIColor? = nil
        var emoji: String? = nil
        var timetable: [DaysOfWeek]? = nil
    }
}
