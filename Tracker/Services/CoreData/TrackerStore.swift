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

	func add(_ tracker: Tracker, to categoryEntity: TrackerCategoryCDEntity?) throws {
		let entity = TrackerCDEntity(context: context)
		entity.id = tracker.id
		entity.name = tracker.name
		entity.emoji = tracker.emoji
		entity.colorHex = tracker.color.toHex()
		entity.schedule = tracker.scheduleString
		entity.date = tracker.date
		entity.category = categoryEntity
		entity.isPinned = tracker.isPinned
	}

	func delete(_ trackerID: UUID) throws {
		let request = fetchRequest(for: trackerID)
		if let object = try context.fetch(request).first {
			context.delete(object)
		}
	}

	func deleteTrackers(in categoryEntity: TrackerCategoryCDEntity) {
		guard let trackers = categoryEntity.trackers as? Set<TrackerCDEntity>, !trackers.isEmpty else {
			return
		}

		for tracker in trackers {
			context.delete(tracker)
		}
	}

	func tracker(from entity: TrackerCDEntity) -> Tracker? {
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
			date: entity.date,
			isPinned: entity.isPinned
		)
	}
	
	func fetchEntity(by id: UUID) throws -> TrackerCDEntity {
		let request = fetchRequest(for: id)
		let results = try context.fetch(request)
		guard let entity = results.first else {
			throw NSError(domain: "TrackerNotFound", code: 404, userInfo: nil)
		}
		return entity
	}

	func makeFetchedResultsController(for date: Date, completed: Bool? = nil) -> NSFetchedResultsController<TrackerCDEntity> {
		let request: NSFetchRequest<TrackerCDEntity> = TrackerCDEntity.fetchRequest()

		let calendar = Calendar.current
		let startOfDay = calendar.startOfDay(for: date)

		guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
			fatalError("Unable to calculate next day for FRC predicate")
		}
		let weekdayRaw = WeekDay.from(date: date).rawValue

		let schedulePredicate = NSPredicate(format: "schedule CONTAINS %@", "\(weekdayRaw)")
		let datePredicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, nextDay as CVarArg)

		let basePredicate = NSCompoundPredicate(type: .or, subpredicates: [schedulePredicate, datePredicate])

		var finalPredicate: NSPredicate = basePredicate

		if let completed = completed {
			let completedPredicate: NSPredicate
			if completed {
				completedPredicate = NSPredicate(
					format: "SUBQUERY(records, $r, $r.date >= %@ AND $r.date < %@).@count > 0",
					startOfDay as CVarArg, nextDay as CVarArg
				)
			} else {
				completedPredicate = NSPredicate(
					format: "SUBQUERY(records, $r, $r.date >= %@ AND $r.date < %@).@count == 0",
					startOfDay as CVarArg, nextDay as CVarArg
				)
			}
			// (schedule OR date) AND completed
			finalPredicate = NSCompoundPredicate(type: .and, subpredicates: [basePredicate, completedPredicate])
		}

		request.predicate = finalPredicate
		request.sortDescriptors = [
			NSSortDescriptor(key: "category.title", ascending: true),
			NSSortDescriptor(key: "name", ascending: true)
		]

		let frc = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: "category.title",
			cacheName: nil
		)

		return frc
	}

	func hasAnyTracker() -> Bool {
		let request = TrackerCDEntity.fetchRequest()
		request.fetchLimit = 1
		let result = try? context.fetch(request)
		return result?.count ?? 0 > 0
	}

	private func fetchRequest(for id: UUID) -> NSFetchRequest<TrackerCDEntity> {
		let request = TrackerCDEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
		return request
	}
}
