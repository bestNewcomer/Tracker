////
////  TrackerStore.swift
////  Tracker
////
////  Created by Ринат Шарафутдинов on 19.03.2024.
////
//
//import CoreData
//import UIKit
//
//final class TrackerStore {
//    
//    static let shared = TrackerStore()
//    
//    // MARK: - Properties
//    private let context: NSManagedObjectContext
//    
//    // MARK: - Initializers
//    convenience init() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        self.init(context: context)
//    }
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//    
//    //MARK:  - Public Methods
//    func addTracker(tracker: Tracker) throws {
//        let trackerCoreData = TrackerCoreData(context: context)
//        updateExistingTracker(trackerCoreData, with: tracker)
//        try context.save()
//    }
//    
//    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
//        trackerCoreData.id = tracker.id
//        trackerCoreData.name = tracker.name
//        trackerCoreData.emoji = tracker.emoji
//        trackerCoreData.color = ColorConvert.convertColorToString(color: tracker.color)
//        trackerCoreData.timetable = tracker.timetable?.compactMap { $0.rawValue }
//    }
//    
//    func createTracker(from tracker: TrackerCoreData) throws -> Tracker {
//        guard
//            let id = tracker.id,
//            let name = tracker.name,
//            let emoji = tracker.emoji,
//            let color = ColorConvert.convertStringToColor(hex: tracker.color!),
//            let timetable = tracker.timetable
//        else { throw TrackerError.decodeError }
//        
//        return Tracker(
//            id: id,
//            name: name,
//            color: color,
//            emoji: emoji,
//            timetable:  timetable.compactMap { DaysOfWeek(rawValue: $0) }
//        )
//    }
//    
//    func fetchTrackers() throws -> [Tracker] {
//        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
//        let trackersFromCoreData = try context.fetch(request)
//        
//        return try trackersFromCoreData.map { try self.createTracker(from: $0) }
//    }
//}
//
//// MARK: - ErrorCaseForStore
//enum TrackerError: Error {
//    case trackerError
//    case decodeError
//}
