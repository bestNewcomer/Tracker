////
////  TrackerRecordStore.swift
////  Tracker
////
////  Created by Ринат Шарафутдинов on 19.03.2024.
////
//
//import CoreData
//import UIKit
//
//final class TrackerRecordStore {
//    
//    // MARK: - Public Properties
//    static let shared = TrackerRecordStore()
//    
//    //MARK:  - Private Properties
//    private let context: NSManagedObjectContext
//    
//    // MARK: - Initialization
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
//    func addNewTracker(_ trackerRecord: TrackerRecord) throws {
//        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
//        trackerRecordCoreData.recordId = trackerRecord.idRecord
//        trackerRecordCoreData.date = trackerRecord.dateRecord
//        try context.save()
//    }
//    
//    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
//        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
//        request.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.idRecord as CVarArg, trackerRecord.dateRecord as CVarArg)
//        if let existingRecord = try context.fetch(request).first {
//            context.delete(existingRecord)
//            try context.save()
//        }
//    }
//    
//    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
//        guard
//            let id = trackerRecordCoreData.recordId,
//            let date = trackerRecordCoreData.date
//        else { throw TrackerError.decodeError }
//        return TrackerRecord(
//            dateRecord: date,
//            idRecord: id
//        )
//    }
//
//    func fetchTrackerRecords() throws -> [TrackerRecord] {
//        let request = TrackerRecordCoreData.fetchRequest()
//        let trackerRecordFromCoreData = try context.fetch(request)
//        return try trackerRecordFromCoreData.map { try self.trackerRecord(from: $0) }
//    }
//}
