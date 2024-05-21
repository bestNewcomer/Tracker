//
//  Localized.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 25.03.2024.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(
            self,
            comment: "\(self) could not be found in Localizable.strings"
        )
    }
}

