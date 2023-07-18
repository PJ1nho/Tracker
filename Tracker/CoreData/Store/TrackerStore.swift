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
//    func trackersFor(_ currentDate: Date, searchRequest: String?)
//    func records(for trackerIndexPath: IndexPath) -> Set<TrackerRecord>
    func getFilteredTrackers(date: Date, searchedText: String) throws
    func getHeaderLabelFor(section: Int) -> String?
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTracker(_ insertedSections: IndexSet, _ deletedSections: IndexSet, _ updatedIndexPaths: [IndexPath], _ insertedIndexPaths: [IndexPath], _ deletedIndexPaths: [IndexPath])
    func updateTrackersCollection()
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

    // MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }


    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }

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

//    private func makeRecord(from recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
//        guard let trackerID = recordCoreData.tracker?.id else {
////            throw TrackerRecordError.invalidTrackerID
//        }
//        guard let date = recordCoreData.date else {
//            throw TrackerRecordError.invalidDate
//        }
//        return TrackerRecord(id: trackerID, date: date)
//    }

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
        let schedule = trackerCoreData.schedule?.components(separatedBy: ",").compactMap({ Int($0) })

        let scheduleFinal = schedule?.compactMap { Schedule(rawValue: $0) }

        return Tracker(id: id, name: name, color: color, emojie: emojie, schedule: scheduleFinal)
    }

}

// MARK: NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTracker(insertedSections, deletedSections, updatedIndexPaths, insertedIndexPaths, deletedIndexPaths)
        clearIndexes()
    }

    // Вызывается, когда изменяется информация о секции результата запроса
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

    func getHeaderLabelFor(section: Int) -> String? {
        guard
            let trackerCoreData = fetchedResultController.sections?[section].objects?.first as? TrackerCoreData
        else { return nil }
        return trackerCoreData.category?.title
    }

    func saveTracker(tracker: Tracker, in category: TrackerCategory) throws {

        let trackerCategory = try categoryStore.getCategoryFromCoreData(id: category.id)

        do {
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.color = UIColor.hexString(color: tracker.color)
            trackerCoreData.emojie = tracker.emojie
            if let schedule = tracker.schedule {
                let scheduleArray = schedule.compactMap { "\($0.rawValue)" }
                trackerCoreData.schedule = scheduleArray.joined(separator: ",")
            } else {
                trackerCoreData.schedule = nil
            }
            trackerCoreData.category = trackerCategory
            trackerCoreData.records = []
            try context.save()
            delegate?.updateTrackersCollection()
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

//    func trackersFor(_ currentDate: Date, searchRequest: String?) {
//        if let searchRequest = searchRequest {
//            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@ AND schedule CONTAINS [n]",
//                                                                         searchRequest,
//                                                                         currentDate as CVarArg)
////            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", searchRequest)
//        } else {
//            fetchedResultController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS [n]",
//                #keyPath(TrackerCoreData.schedule), currentDate as CVarArg)
//        }
//        try? fetchedResultController.performFetch()
//    }

    func getFilteredTrackers(date: Date, searchedText: String) throws {
        var predicates = [NSPredicate]()
        let dayOfWeekIndex = Calendar.current.component(.weekday, from: date)
        let iso860DayOfWeekIndex = dayOfWeekIndex > 1 ? dayOfWeekIndex - 2 : dayOfWeekIndex + 5

        predicates.append(createSchedulePredicate("\(iso860DayOfWeekIndex)"))

        if searchedText.isEmpty == false {
            predicates.append(createSearchPredicate(searchedText))
        }
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultController.fetchRequest.predicate = compoundPredicate

        try fetchedResultController.performFetch()
//        delegate?.updateTrackers()
    }

    private func createWeekdayRegex(_ iso860DayOfWeekIndex: Int) -> String {
        var weekdayPattern = ""
        for index in 0..<7 {
            if index == iso860DayOfWeekIndex {
                weekdayPattern += "1"
            } else {
                weekdayPattern += "."
            }
        }
        return weekdayPattern
    }


    private func createSchedulePredicate(_ dayOfWeekIndex: String) -> NSPredicate {
        return NSPredicate(format: "%K == nil OR (%K != nil AND %@ IN %K)",
                           #keyPath(TrackerCoreData.schedule),
                           #keyPath(TrackerCoreData.schedule),
                           dayOfWeekIndex,
                           #keyPath(TrackerCoreData.schedule))
    }


    private func createSearchPredicate(_ searchedText: String) -> NSPredicate {
        return NSPredicate(format: "%K CONTAINS %@",
                           #keyPath(TrackerCoreData.name), searchedText)
    }

//    func records(for trackerIndexPath: IndexPath) -> Set<TrackerRecord> {
//        let trackerCoreData = fetchedResultController.object(at: trackerIndexPath)
//        guard let trackerRecordsCoreData = trackerCoreData.records as? Set<TrackerRecordCoreData> else {
//            return Set<TrackerRecord>()
//        }
//        do {
//            let trackerRecords = try trackerRecordsCoreData.map { try makeRecord(from: $0)}
//            return Set(trackerRecords)
//        } catch {
//            return Set<TrackerRecord>()
//        }
//    }
}

//protocol TrackerStore {
//    var managedObjectContext: NSManagedObjectContext? { get }
//    func add(_ record: NotepadRecord) throws
//    func delete(_ record: NSManagedObject) throws
//}

//class TrackerStore {
//    private let modelName = "Tracker"
//    private let storeURL = NSPersistentContainer
//                                .defaultDirectoryURL()
//                                .appendingPathComponent("data-store.sqlite")
//    private let container: NSPersistentContainer
//    private let context: NSManagedObjectContext
//
//    enum TrackerStoreError: Error {
//        case modelNotFound
//        case failedToLoadPersistentContainer(Error)
//    }
//
//    init() throws {
//        guard let modelUrl = Bundle(for: TrackerStore.self).url(forResource: modelName, withExtension: "momd"),
//              let model = NSManagedObjectModel(contentsOf: modelUrl) else {
//            throw TrackerStoreError.modelNotFound
//        }
//
//        do {
//            container = try NSPersistentContainer.load(name: modelName, model: model, url: storeURL)
//            context = container.newBackgroundContext()
//        } catch {
//            throw TrackerStoreError.failedToLoadPersistentContainer(error)
//        }
//    }
//
//    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
//        let context = self.context
//        var result: Result<R, Error>!
//        context.performAndWait { result = action(context) }
//        return try result.get()
//    }
//
//    private func cleanUpReferencesToPersistentStores() {
//        context.performAndWait {
//            let coordinator = self.container.persistentStoreCoordinator
//            try? coordinator.persistentStores.forEach(coordinator.remove)
//        }
//    }
//
//    deinit {
//        cleanUpReferencesToPersistentStores()
//    }
//}
//
//extension NSPersistentContainer {
//    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
//        let description = NSPersistentStoreDescription(url: url)
//        let container = NSPersistentContainer(name: name, managedObjectModel: model)
//        container.persistentStoreDescriptions = [description]
//
//        var loadError: Swift.Error?
//        container.loadPersistentStores { loadError = $1 }
//        try loadError.map { throw $0 }
//
//        return container
//    }
//}
