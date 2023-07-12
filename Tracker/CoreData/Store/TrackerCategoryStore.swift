//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Тихтей  Павел on 23.06.2023.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    enum CategoryStoreError: Error {
        case decodeError
    }
    
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    lazy var categories: [TrackerCategory] = {
        do {
            let request = TrackerCategoryCoreData.fetchRequest()
            let result = try context.fetch(request)
            return try result.map { try createCategory(from: $0) }
        } catch {
            return []
        }
    }()
    
    
    // MARK: - Methods
    func getCategoryFromCoreData(id: UUID) throws -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
        let category = try context.fetch(request).first
        return category
    }
    
//    func saveCategory(category: TrackerCategory) throws {
//        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
//    }

    private func createCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = coreData.title
        else { throw CategoryStoreError.decodeError }
        let id = UUID(uuidString: coreData.categoryId ?? "")
        return TrackerCategory(id: id ?? UUID(), title: title, trackers: [])

    }

    private func setupMockCategories(with context: NSManagedObjectContext) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(request)
        
        guard result.isEmpty else {
            categories = try result.map { try createCategory(from: $0) }
            return
        }
        
        let _ = [
            TrackerCategory(id: UUID(), title: "Домашний уют", trackers: []),
            TrackerCategory(id: UUID(), title: "Радостные мелочи", trackers: []),
            TrackerCategory(id: UUID(), title: "Самочувствие", trackers: []),
            TrackerCategory(id: UUID(), title: "Привычки", trackers: []),
            TrackerCategory(id: UUID(), title: "Внимательность", trackers: []),
            TrackerCategory(id: UUID(), title: "Спорт", trackers: [])
        ].map { category in
            let categoryFromCoreData = TrackerCategoryCoreData(context: context)
            categoryFromCoreData.title = category.title
            categoryFromCoreData.trackers = NSSet(array: category.trackers)
            categoryFromCoreData.categoryId = category.id.uuidString
            return categoryFromCoreData
        }
        try context.save()
    }
    
    
    // MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        try setupMockCategories(with: context)
    }
}


