//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 25.01.2024.
//

import Foundation

struct TrackerCategory {
    let title: String
    let trackersArray: [Tracker]
    
    func visibleTrackers(filterString: String, pin: Bool?) -> [Tracker] {
        if filterString.isEmpty {
            return pin == nil ? trackersArray : trackersArray.filter { $0.isPinned == pin }
        } else {
            return pin == nil ? trackersArray
                .filter { $0.name.lowercased().contains(filterString.lowercased()) }
            : trackersArray
                .filter { $0.name.lowercased().contains(filterString.lowercased()) }
                .filter { $0.isPinned == pin }
        }
    }
}
