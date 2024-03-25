//
//  DaysString.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 25.03.2024.
//

import Foundation

extension Int {
  
  // MARK: - Word Declension Method
  func daysString() -> String {
    if self == 0 {
        return String(format: NSLocalizedString("days", comment: " could not be found in Localizable.strings"), self)
    }
    
    let absValue = abs(self)
    
    let lastTwoDigits = absValue % 100
    
    if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
      return String(format: NSLocalizedString("days", comment: " could not be found in Localizable.strings"), self)
    } else {
      let lastDigit = absValue % 10
      
      switch lastDigit {
      case 1:
          return String(format: NSLocalizedString("day2", comment: " could not be found in Localizable.strings"), self)
      case 2, 3, 4:
          return String(format: NSLocalizedString("day1", comment: " could not be found in Localizable.strings"), self)
      default:
        return String(format: NSLocalizedString("days", comment: " could not be found in Localizable.strings"), self)
      }
    }
  }
}
