//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

import Foundation
import CoreData

final class TrackerCategoryStore {

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
	}

	func getOrCreateCategoryEntity(for title: String) throws -> TrackerCategoryEntity {
		let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
		request.predicate = NSPredicate(format: "title == %@", title)

		if let existing = try context.fetch(request).first {
			return existing
		}

		let newEntity = TrackerCategoryEntity(context: context)
		newEntity.title = title

		return newEntity
	}

	func getOrCreateCategoryEntity(for category: TrackerCategory) throws -> TrackerCategoryEntity {
		try getOrCreateCategoryEntity(for: category.title)
	}

	func fetchAll() throws -> [TrackerCategoryEntity] {
		let request = TrackerCategoryEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return try context.fetch(request)
	}

	func delete(_ category: TrackerCategory) throws {
		let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
		request.predicate = NSPredicate(format: "title == %@", category.title)

		if let entity = try context.fetch(request).first {
			context.delete(entity)
			try context.save()
		}
	}

	func delete(_ category: TrackerCategoryEntity) {
		context.delete(category)
	}
}
