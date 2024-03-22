//
//  TrackerStore.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 19.03.2024.
//

import CoreData
import UIKit

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    weak var delegate: TrackerStoreDelegate?
    var trackers: [Tracker] {
        guard let objects = self.fetchedResultsController.fetchedObjects, let trackers = try? objects.map({ try self.createTracker(from: $0)})
        else { return [] }
        return trackers
    }
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    // MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("TrackerStore fetch failed")
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
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
    func addTracker(tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        try context.save()
    }
    
    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = ColorConvert.convertColorToString(color: tracker.color)
        trackerCoreData.timetable = tracker.timetable?.compactMap { $0.rawValue }
    }
    
    func updateTracker(
        newTitle: String,
        newEmoji: String,
        newColor: String,
        newSchedule: [DaysOfWeek],
        categoryTitle: String,
        editableTracker: Tracker) throws {
            let tracker = fetchedResultsController.fetchedObjects?.first {
                $0.id == editableTracker.id
            }
            tracker?.name = newTitle
            tracker?.emoji = newEmoji
            tracker?.color = newColor
            tracker?.timetable = newSchedule.compactMap { $0.rawValue }
            if (tracker?.category?.title != categoryTitle) {
                tracker?.category = TrackerCategoryStore().category(categoryTitle)
            }
            try context.save()
        }
    
    func deleteTracker(_ trackerToDelete: Tracker) throws {
        let tracker = fetchedResultsController.fetchedObjects?.first {
            $0.id == trackerToDelete.id
        }
        if let tracker = tracker {
            context.delete(tracker)
            try context.save()
        }
    }
    
    func createTracker(from tracker: TrackerCoreData) throws -> Tracker {
        guard
            let id = tracker.id,
            let name = tracker.name,
            let emoji = tracker.emoji,
            let color = ColorConvert.convertStringToColor(hex: tracker.color!),
            let timetable = tracker.timetable
        else { throw TrackerError.decodeError }
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            timetable:  timetable.compactMap { DaysOfWeek(rawValue: $0) }
        )
    }
    
    func fetchTrackers() throws -> [Tracker] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackersFromCoreData = try context.fetch(request)
        
        return try trackersFromCoreData.map { try self.createTracker(from: $0) }
    }
}

// MARK: - ErrorCaseForStore
enum TrackerError: Error {
    case trackerError
    case decodeError
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            insertedIndexes = IndexSet()
            deletedIndexes = IndexSet()
            updatedIndexes = IndexSet()
            movedIndexes = Set<TrackerStoreUpdate.Move>()
        }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            delegate?.store(
                self,
                didUpdate: TrackerStoreUpdate(
                    insertedIndexes: insertedIndexes ?? [],
                    deletedIndexes: deletedIndexes ?? [],
                    updatedIndexes: updatedIndexes ?? [],
                    movedIndexes: movedIndexes ?? []
                )
            )
            insertedIndexes = nil
            deletedIndexes = nil
            updatedIndexes = nil
            movedIndexes = nil
        }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {
                assertionFailure("insert indexPath - nil")
                return
            }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else {
                assertionFailure("delete indexPath - nil")
                return
            }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else {
                assertionFailure("update indexPath - nil")
                return
            }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {
                assertionFailure("move indexPath - nil")
                return
            }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            assertionFailure("unknown case")
        }
    }
}
