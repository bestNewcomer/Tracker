//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 25.01.2024.
//

import Foundation

struct TrackerRecord: Hashable {
    let idRecord: UUID
    let dateRecord: Date
    let trackerId: UUID
    
    init(idRecord: UUID = UUID(), dateRecord: Date, trackerId: UUID) {
        self.idRecord = idRecord
        self.dateRecord = dateRecord
        self.trackerId = trackerId
    }
}
