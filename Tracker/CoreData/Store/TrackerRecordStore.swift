//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Тихтей  Павел on 23.06.2023.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdate(records: Set<TrackerRecord>)
}

final class TrackerRecordStore: NSObject {
    enum CategoryStoreError: Error {
        case decodeError
    }


    // MARK: - Properties
    weak var delegate: TrackerRecordStoreDelegate?

    private let context: NSManagedObjectContext
    private var completedTrackers: Set<TrackerRecord> = []
    private let trackerStore = TrackerStore()

    // MARK: - Methods
    private func createTrackerRecord(from coreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let date = coreData.date,
            let id = coreData.trackerId
//            let tracker = try? trackerStore.createTracker(from: trackerCoreData)
        else
        { throw CategoryStoreError.decodeError }

        return TrackerRecord(id: id, date: date)
    }


    // MARK: - Methods
    func getCompletedTrackers() throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
//        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate)
        let recordsCoreData = try context.fetch(request)
        let records = try recordsCoreData.map { try createTrackerRecord(from: $0) }
        completedTrackers = Set(records)
        delegate?.didUpdate(records: completedTrackers)
    }


    func add(record: TrackerRecord) throws {
//        let trackerCoreData = try trackerStore.getTrackerFromCoreData(id: record.trackerId)
        let trackerRecordFromCoreData = TrackerRecordCoreData(context: context)
        trackerRecordFromCoreData.trackerId = record.id
        trackerRecordFromCoreData.date = DateFormatterService.shared.getFormatterDate(date: record.date) 
        try context.save()
        completedTrackers.insert(record)
        delegate?.didUpdate(records: completedTrackers)
    }


    func remove(record: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.trackerId), record.id.uuidString
        )
        let records = try context.fetch(request)
        guard let recordToRemove = records.first else { return }
        context.delete(recordToRemove)
        try context.save()
        completedTrackers.remove(record)
        delegate?.didUpdate(records: completedTrackers)
    }


    // MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }


    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }

}

