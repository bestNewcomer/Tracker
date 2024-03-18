//
//  TestData.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 15.03.2024.
//

import Foundation

class TestData {
    static let shared = TestData()
    private var categories: [TrackerCategory] = []
    
    private init() {}
    
    func getDummyTrackers() -> [TrackerCategory] {
        
        if !categories.isEmpty {
            return categories
        }
        
        let schedule1 = Schedule(markedDays: [.monday])
        let schedule2 = Schedule(markedDays: [.monday, .wednesday, .thursday, .friday])
        let schedule3 = Schedule(markedDays: [.saturday, .sunday])
        
        let tracker1 = Tracker(id: UUID(), name: "Поливать растения", color: .colorSelection5, emoji: "❤️", timetable: schedule1)
        let tracker2 = Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .colorSelection2, emoji: "😻", timetable: schedule2)
        let tracker3 = Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: .colorSelection1, emoji: "🌺", timetable: schedule3)
        let tracker4 = Tracker(id: UUID(), name: "Свидание в апреле", color: .colorSelection14, emoji: "❤️", timetable: schedule2)
        
        let dummyCategories = [ TrackerCategory(title: "Домашний уют", trackersArray: [tracker1]),
                                TrackerCategory(title: "Радостные мелочи", trackersArray: [tracker2, tracker3, tracker4])]
        categories.append(contentsOf: dummyCategories)
    
        return categories
    }
}

