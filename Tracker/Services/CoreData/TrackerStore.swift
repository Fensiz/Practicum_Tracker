//
//  TrackerStore.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

import Foundation
import CoreData
import UIKit

final class TrackerStore {

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
	}

	func add(_ tracker: Tracker, to categoryEntity: TrackerCategoryEntity?) throws {
		let entity = TrackerEntity(context: context)
		entity.id = tracker.id
		entity.name = tracker.name
		entity.emoji = tracker.emoji
		entity.colorHex = tracker.color.toHex()
		entity.schedule = tracker.scheduleData
		entity.date = tracker.date
		entity.category = categoryEntity

		try context.save()
	}

	func delete(_ trackerID: UUID) throws {
		let request = fetchRequest(for: trackerID)
		if let object = try context.fetch(request).first {
			context.delete(object)
			try context.save()
		}
	}

	func fetch(by id: UUID) throws -> Tracker? {
		let request = fetchRequest(for: id)
		guard let entity = try context.fetch(request).first else { return nil }
		return tracker(from: entity)
	}

	func fetchAll() throws -> [Tracker] {
		let request = TrackerEntity.fetchRequest()
		let result = try context.fetch(request)
		return result.compactMap { tracker(from: $0) }
	}

	func makeFetchedResultsController() -> NSFetchedResultsController<TrackerEntity> {
		let request = TrackerEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
	}

	func tracker(from entity: TrackerEntity) -> Tracker? {
		guard let id = entity.id,
			  let name = entity.name,
			  let emoji = entity.emoji,
			  let colorHex = entity.colorHex,
			  let color = UIColor(hex: colorHex) else {
			return nil
		}

		return Tracker(
			id: id,
			name: name,
			color: color,
			emoji: emoji,
			schedule: entity.scheduleSet,
			date: entity.date
		)
	}

	private func fetchRequest(for id: UUID) -> NSFetchRequest<TrackerEntity> {
		let request = TrackerEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
		return request
	}
}
