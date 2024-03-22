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
    
    func visibleTrackers(filterString: String) -> [Tracker] {
        if filterString.isEmpty {
            return trackersArray
        } else {
            return trackersArray.filter {
                $0.name.lowercased().contains(filterString.lowercased()) }
        }
    }
}
