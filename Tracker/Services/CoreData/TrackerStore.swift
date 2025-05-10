//
//  TrackerStore.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

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
		entity.schedule = tracker.scheduleString
		entity.date = tracker.date
		entity.category = categoryEntity
	}

	func delete(_ trackerID: UUID) throws {
		let request = fetchRequest(for: trackerID)
		if let object = try context.fetch(request).first {
			context.delete(object)
		}
	}

	func deleteTrackers(in categoryEntity: TrackerCategoryEntity) {
		guard let trackers = categoryEntity.trackers as? Set<TrackerEntity>, !trackers.isEmpty else {
			return
		}

		for tracker in trackers {
			context.delete(tracker)
		}
	}

	func tracker(from entity: TrackerEntity) -> Tracker? {
		guard let id = entity.id,
			  let name = entity.name,
			  let emoji = entity.emoji,
			  let colorHex = entity.colorHex,
			  let color = UIColor(hex: colorHex) else {
			return nil
		}

		var schedule: Set<WeekDay>? = nil
		if let rawValues = entity.schedule {
			schedule = Set(rawValues
				.split(separator: ",")
				.compactMap({ Int($0) })
				.compactMap { WeekDay(rawValue: $0) }
			)
		}

		return Tracker(
			id: id,
			name: name,
			color: color,
			emoji: emoji,
			schedule: schedule,
			date: entity.date
		)
	}
	
	func fetchEntity(by id: UUID) throws -> TrackerEntity {
		let request = fetchRequest(for: id)
		let results = try context.fetch(request)
		guard let entity = results.first else {
			throw NSError(domain: "TrackerNotFound", code: 404, userInfo: nil)
		}
		return entity
	}

	private func fetchRequest(for id: UUID) -> NSFetchRequest<TrackerEntity> {
		let request = TrackerEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
		return request
	}
}
