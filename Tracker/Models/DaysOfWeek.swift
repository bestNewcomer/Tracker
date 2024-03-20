//
//  WeekDays.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 02.03.2024.
//

import Foundation

struct Schedule {
    var markedDays: [DaysOfWeek] = []
    
    var scheduleText: String {
        let daysText = markedDays.map { $0.reductions }
        return daysText.joined(separator: ", ")
    }
    
    func isReccuringOn(_ day: DaysOfWeek) -> Bool {
        return markedDays.contains(day)
    }
}

enum DaysOfWeek: Int, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    static func < (lhs: DaysOfWeek, rhs: DaysOfWeek) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension DaysOfWeek {
    var translation: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var reductions: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
    
    static func transformedSked(value: [DaysOfWeek]?) -> String? {
        guard let value = value else { return nil }
        let index = value.map { self.allCases.firstIndex(of: $0) }
        var result = ""
        for i in 0..<7 {
            if index.contains(i) {
                result += "1"
            } else {
                result += "0"
            }
        }
        return result
    }
    
    static func reversTransformedSked(value: String?) -> [DaysOfWeek]? {
        guard let value = value else { return nil }
        var weekdays = [DaysOfWeek]()
        for (index,char) in value.enumerated() {
            guard char == "1" else { continue }
            let weekday = self.allCases[index]
            weekdays.append(weekday)
        }
        return weekdays
    }
}

extension Date {
    func toWeekday() -> DaysOfWeek {
        let calendar = Calendar.current
        let dayNumber = calendar.component(.weekday, from: self)
        switch dayNumber {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            fatalError("Invalid day number")
        }
    }
}
