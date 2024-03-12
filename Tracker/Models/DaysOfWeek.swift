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
}

enum DaysOfWeek: Int {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
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
}
