//
//  DateFormatter.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 08.01.2024.
//

import Foundation


extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let formatterDate = ISO8601DateFormatter()
}
