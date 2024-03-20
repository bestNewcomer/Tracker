//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 19.03.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Properties
    var category = [TrackerCategory]()
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        do {
                try self.init(context: context)
            } catch {
                fatalError("Failed to initialize with error: \(Error.self)")
            }

    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        try setupCategory(with: context)
    }
    
    // MARK: - Methods
    
    func takeCategory(with id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title), id.uuidString)
        let category = try context.fetch(request)
        return category[0]
    }
    
    private func createCategoryForTrackers(from data: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = data.title,
              let stringID = data.categoryId,
              let id = UUID(uuidString: stringID) else { throw TrackerError.decodeError }
        return TrackerCategory(id: id, title: title, trackersArray: [])
    }
    
    private func setupCategory(with context: NSManagedObjectContext) throws {
        let fetchResult = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        guard fetchResult.isEmpty else {
               category = try fetchResult.map({ try createCategoryForTrackers(from: $0) })
               return
           }
        let categories = [
            TrackerCategory(id: UUID(), title: "Важное", trackersArray: []),
            TrackerCategory(id: UUID(), title: "Средней важности", trackersArray: []),
            TrackerCategory(id: UUID(), title: "Низкой важности", trackersArray: [])
        ]
        
        _ = categories.map { category in
            let cd = TrackerCategoryCoreData(context: context)
            cd.categoryId = category.id.uuidString
            cd.createdAt = Date()
            cd.title = category.title
            return cd
        }
        try context.save()
    }
}
