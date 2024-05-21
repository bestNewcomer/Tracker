//
//  Filter.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 27.03.2024.
//

import Foundation

enum Filter: String, CaseIterable {
    case all = "Все трекеры"
    case completed = "Завершенные"
    case incompleted = "Не завершенные"
    case today = "Трекеры на сегодня"
}

