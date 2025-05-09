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

	func add(_ category: TrackerCategory) throws {
		let entity = TrackerCategoryEntity(context: context)
		entity.title = category.title

		try context.save()
	}

	func delete(_ category: TrackerCategory) throws {
		let request = fetchRequest(for: category.title)
		if let object = try context.fetch(request).first {
			context.delete(object)
			try context.save()
		}
	}

	func update(title oldTitle: String, to newTitle: String) throws {
		let request = fetchRequest(for: oldTitle)
		if let object = try context.fetch(request).first {
			object.title = newTitle
			try context.save()
		}
	}

	func fetchAll() throws -> [TrackerCategory] {
		let request = TrackerCategoryEntity.fetchRequest()
		let result = try context.fetch(request)
		return result.compactMap { category(from: $0) }
	}

	func makeFetchedResultsController() -> NSFetchedResultsController<TrackerCategoryEntity> {
		let request = TrackerCategoryEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
	}

	private func fetchRequest(for title: String) -> NSFetchRequest<TrackerCategoryEntity> {
		let request = TrackerCategoryEntity.fetchRequest()
		request.predicate = NSPredicate(format: "title == %@", title)
		return request
	}

	private func category(from entity: TrackerCategoryEntity) -> TrackerCategory? {
		guard let title = entity.title else { return nil }

		let trackers: [Tracker] = (entity.trackers as? Set<TrackerEntity>)?
			.compactMap { TrackerStore(context: context).tracker(from: $0) } ?? []

		return TrackerCategory(title: title, trackers: trackers)
	}
}
