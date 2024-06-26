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
    let timetable: [DaysOfWeek]?
    let isPinned: Bool?
    
    var category: TrackerCategory? {
        return TrackerCategoryStore().category(forTracker: self)
    }
}


