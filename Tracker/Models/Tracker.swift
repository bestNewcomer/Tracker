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
    let daysCount: Int

    init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, timetable: Schedule?, daysCount: Int) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.timetable = timetable
        self.daysCount = daysCount
    }
}

extension Tracker {
    struct Track {
        var name: String = ""
        var color: UIColor? = nil
        var emoji: String? = nil
        var timetable: Schedule? = nil
        var daysCount = 0
    }
}

