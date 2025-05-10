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

	func getOrCreateCategoryEntity(for title: String) throws -> TrackerCategoryCDEntity {
		let request: NSFetchRequest<TrackerCategoryCDEntity> = TrackerCategoryCDEntity.fetchRequest()
		request.predicate = NSPredicate(format: "title == %@", title)

		if let existing = try context.fetch(request).first {
			return existing
		}

		let newEntity = TrackerCategoryCDEntity(context: context)
		newEntity.title = title

		return newEntity
	}

	func getOrCreateCategoryEntity(for category: TrackerCategory) throws -> TrackerCategoryCDEntity {
		try getOrCreateCategoryEntity(for: category.title)
	}

	func fetchAll() throws -> [TrackerCategoryCDEntity] {
		let request = TrackerCategoryCDEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return try context.fetch(request)
	}

	func delete(_ category: TrackerCategory) throws {
		let request: NSFetchRequest<TrackerCategoryCDEntity> = TrackerCategoryCDEntity.fetchRequest()
		request.predicate = NSPredicate(format: "title == %@", category.title)

		if let entity = try context.fetch(request).first {
			context.delete(entity)
			try context.save()
		}
	}

	func delete(_ category: TrackerCategoryCDEntity) {
		context.delete(category)
	}
}
