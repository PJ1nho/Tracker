//
//  TrackerStore.swift
//  Tracker
//
//  Created by Тихтей  Павел on 23.06.2023.
//

import CoreData
import UIKit

// MARK: Protocols

protocol TrackerStoreProtocol {
    var numberOfSections: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func name(of section: Int) -> String?
    func object(at indexPath: IndexPath) -> Tracker?
    func saveTracker(tracker: Tracker, in category: TrackerCategory) throws
    func deleteTracker(at indexPath: IndexPath) throws
    func trackersFor(_ currentDate: Date, searchRequest: String?)
    func records(for trackerIndexPath: IndexPath) -> Set<TrackerRecord>
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTracker(_ insertedSections: IndexSet, _ deletedSections: IndexSet, _ updatedIndexPaths: [IndexPath], _ insertedIndexPaths: [IndexPath], _ deletedIndexPaths: [IndexPath])
}

// MARK: Enum

enum TrackerStoreError: Error {
    case invalidTrackerID
    case invalidTrackerName
    case invalidTrackerColor
    case invalidTrackerEmoji
    case invalidTrackerSchedule
    case hexDeserializationError
}

// MARK: TrackerStore

class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    weak var delegate: TrackerStoreDelegate?
    private var insertedIndexPaths: [IndexPath] = []
    private var deletedIndexPaths: [IndexPath] = []
    private var updatedIndexPaths: [IndexPath] = []
    private var insertedSections = IndexSet()
    private var deletedSections = IndexSet()
    private var categoryStore = TrackerCategoryStore()

    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)]

//        let key = #keyPath (TrackerCoreData.schedule)
//        print(key)
//        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[n] %@",
//                                             #keyPath (TrackerCoreData.schedule),
//                                             [Schedule.friday.rawValue,
//                                              Schedule.monday.rawValue,
//                                              Schedule.saturday.rawValue,
//                                              Schedule.sunday.rawValue,
//                                              Schedule.thursday.rawValue,
//                                              Schedule.tuesday.rawValue,
//                                              Schedule.wednesday.rawValue])

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil)

        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()

    init(context: NSManagedObjectContext, delegate: TrackerStoreDelegate) {
        self.context = context
        self.delegate = delegate
    }

    convenience init(delegate: TrackerStoreDelegate) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: appDelegate not found")
        }
        self.init(context: appDelegate.persistentContainer.viewContext, delegate: delegate)
    }

    private func clearIndexes() {
        insertedIndexPaths = []
        deletedIndexPaths = []
        updatedIndexPaths = []
        insertedSections = IndexSet()
        deletedSections = IndexSet()
    }

    private func makeRecord(from recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerID = recordCoreData.tracker?.id else {
            throw TrackerRecordError.invalidTrackerID
        }
        guard let date = recordCoreData.date else {
            throw TrackerRecordError.invalidDate
        }
        return TrackerRecord(id: trackerID, date: date)
    }

    private func makeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.invalidTrackerID
        }
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.invalidTrackerName
        }
        guard let colorHex = trackerCoreData.color else {
            throw TrackerStoreError.invalidTrackerColor
        }
        guard let color = UIColor.deserialize(hexString: colorHex) else {
            throw TrackerStoreError.hexDeserializationError
        }
        guard let emojie = trackerCoreData.emojie else {
            throw TrackerStoreError.invalidTrackerEmoji
        }
        guard let schedule = trackerCoreData.schedule else {
            throw TrackerStoreError.invalidTrackerSchedule
        }
        let scheduleFinal = schedule.compactMap { Schedule(rawValue: $0)}

        return Tracker(id: id, name: name, color: color, emojie: emojie, schedule: scheduleFinal )
    }

}

// MARK: NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTracker(insertedSections, deletedSections, updatedIndexPaths, insertedIndexPaths, deletedIndexPaths)
        clearIndexes()
    }

    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert :
            insertedSections.insert(sectionIndex)
        case .delete :
            deletedSections.insert(sectionIndex)
        default: break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert :
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        case .delete :
            if let indexPath = indexPath {
                deletedIndexPaths.append(indexPath)
            }
        case .update :
            if let indexPath = indexPath {
                updatedIndexPaths.append(indexPath)
            }
        default: break
        }
    }
}

// MARK: TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {

    var numberOfSections: Int {
        fetchedResultController.sections?.count ?? 0
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    func name(of section: Int) -> String? {
        fetchedResultController.sections?[section].name
    }

    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        return try? makeTracker(from: trackerCoreData)
    }

    func saveTracker(tracker: Tracker, in category: TrackerCategory) throws {
//        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
//        request.returnsObjectsAsFaults = false
//        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), category)

//        guard var categoryCoreData = try? context.fetch(request) else { return }
//        if categoryCoreData.isEmpty {
//            let model = TrackerCategoryCoreData(context: context)
//            model.title = category
//            model.trackers = []
//            do {
//                try context.save()
//                categoryCoreData = try context.fetch(request)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }

        let trackerCategory = try categoryStore.getCategoryFromCoreData(id: category.id)

        do {
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.color = UIColor.hexString(color: tracker.color)
            trackerCoreData.emojie = tracker.emojie
            trackerCoreData.schedule = tracker.schedule.map {$0.rawValue}
            trackerCoreData.category = trackerCategory
//            trackerCoreData.records = []
            try context.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteTracker(at indexPath: IndexPath) throws {
        let trackerCoreData = fetchedResultController.object(at: indexPath)
        context.delete(trackerCoreData)
        try context.save()
    }

    func trackersFor(_ currentDate: Date, searchRequest: String?) {
        if let searchRequest = searchRequest {
            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS [n] %@ AND %K CONTAINS [n]", #keyPath(TrackerCoreData.schedule), currentDate as CVarArg,
                #keyPath(TrackerCoreData.name), searchRequest)
        } else {
            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS [n]",
                #keyPath(TrackerCoreData.schedule), currentDate as CVarArg)
        }
    }

    func records(for trackerIndexPath: IndexPath) -> Set<TrackerRecord> {
        let trackerCoreData = fetchedResultController.object(at: trackerIndexPath)
        guard let trackerRecordsCoreData = trackerCoreData.records as? Set<TrackerRecordCoreData> else {
            return Set<TrackerRecord>()
        }
        do {
            let trackerRecords = try trackerRecordsCoreData.map { try makeRecord(from: $0)}
            return Set(trackerRecords)
        } catch {
            return Set<TrackerRecord>()
        }
    }
}

