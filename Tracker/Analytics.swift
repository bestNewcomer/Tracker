//
//  Analytics.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 28.03.2024.
//

import Foundation
import YandexMobileMetrica

struct Analytics {
    func report(
        event: Events,
        params : [AnyHashable : Any]
    ) {
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

enum Events: String, CaseIterable {
    case open = "open"
    case close = "close"
    case click = "click"
}

enum Items: String, CaseIterable {
    case add_track = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}
