//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 19.03.2024.
//

import CoreData
import UIKit

final class TrackerRecordStore {
    // MARK: - Public Properties
    
    //MARK:  - Private Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
