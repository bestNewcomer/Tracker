//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 19.03.2024.
//

import CoreData
import UIKit

struct TrackerRecordStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate)
}

final class TrackerRecordStore: NSObject {
    
    // MARK: - Public Properties
    static let shared = TrackerRecordStore()
    weak var delegate: TrackerRecordStoreDelegate?
    var trackerRecords: [TrackerRecord] {
        guard let objects = self.fetchedResultsController.fetchedObjects,
              let records = try? objects.map ({
                  try self.trackerRecord(from: $0)
              })
        else { return [] }

        return records
    }
    
    //MARK:  - Private Properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerRecordStoreUpdate.Move>?
    
    // MARK: - Initialization
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("TrackerRecordStore fetch failed")
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
    }
    
    //MARK:  - Public Methods
    func addNewTracker(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.recordId = trackerRecord.idRecord
        trackerRecordCoreData.date = trackerRecord.dateRecord
        try context.save()
    }
    
//    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
//        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
//        request.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.idRecord as CVarArg, trackerRecord.dateRecord as CVarArg)
//        if let existingRecord = try context.fetch(request).first {
//            context.delete(existingRecord)
//            try context.save()
//        }
//    }
    func deleteTrackerRecord(with id: UUID, date: Date) throws {
        let record = fetchedResultsController.fetchedObjects?.first {
            $0.recordId == id &&
            $0.date?.yearMonthDayComponents == date.yearMonthDayComponents
        }

        if let record = record {
            context.delete(record)
            try context.save()
        }
        reload()
    }
    
    func deleteAllTrackerRecords(with trackerID: UUID) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        do {
            let allRecords = try context.fetch(request)
            for record in allRecords {
                context.delete(record)
            }
            try context.save()
        } catch {
            throw error
        }
    }
    
    func reload() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Не удалось обновить данные в хранилище: \(error)")
        }
    }

    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = trackerRecordCoreData.recordId,
            let date = trackerRecordCoreData.date
        else { throw TrackerError.decodeError }
        return TrackerRecord(
            dateRecord: date,
            idRecord: id
        )
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerRecordStoreUpdate.Move>()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedIndexes,
            let deletedIndexes,
            let updatedIndexes,
            let movedIndexes
        else { return }

        delegate?.store(
            self,
            didUpdate: TrackerRecordStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                movedIndexes: movedIndexes
            )
        )
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath else { return }
            deletedIndexes?.insert(indexPath.item)
        case.insert:
            guard let indexPath = newIndexPath else { return }
            insertedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath else { return }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        default:
            break
        }
    }
}
