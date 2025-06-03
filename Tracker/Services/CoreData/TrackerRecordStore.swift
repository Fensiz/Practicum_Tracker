//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

import Foundation
import CoreData

final class TrackerRecordStore {

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
	}

	func add(record: TrackerRecord) throws {
		let request: NSFetchRequest<TrackerCDEntity> = TrackerCDEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %@", record.id as CVarArg)

		guard let TrackerCDEntity = try context.fetch(request).first else {
			throw NSError(domain: "TrackerRecordStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
		}

		let entity = TrackerRecordCDEntity(context: context)
		entity.date = record.date
		entity.tracker = TrackerCDEntity

		try context.save()
	}

	func delete(record: TrackerRecord) throws {
		let request = fetchRequest(for: record.id, date: record.date)
		if let object = try context.fetch(request).first {
			context.delete(object)
			try context.save()
		}
	}

	func contains(_ record: TrackerRecord) throws -> Bool {
		let request = fetchRequest(for: record.id, date: record.date)
		request.fetchLimit = 1
		let count = try context.count(for: request)
		return count > 0
	}

	func completedCount(for trackerID: UUID) throws -> Int {
		let request = fetchRequest(for: trackerID)
		return try context.count(for: request)
	}

	func fetchAll() throws -> [TrackerRecord] {
		let request = TrackerRecordCDEntity.fetchRequest()
		let entities = try context.fetch(request)
		return entities.compactMap { record(from: $0) }
	}

	func fetchAllRecords() -> [TrackerRecord] {
		(try? fetchAll()) ?? []
	}

	// MARK: - Private

	private func record(from entity: TrackerRecordCDEntity) -> TrackerRecord? {
		guard let tracker = entity.tracker,
			  let id = tracker.id,
			  let date = entity.date else {
			return nil
		}
		return TrackerRecord(id: id, date: date)
	}

	private func fetchRequest(for trackerID: UUID, date: Date? = nil) -> NSFetchRequest<TrackerRecordCDEntity> {
		let request: NSFetchRequest<TrackerRecordCDEntity> = TrackerRecordCDEntity.fetchRequest()

		var predicates: [NSPredicate] = [
			NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
		]

		if let date {
			let calendar = Calendar.current
			let startOfDay = calendar.startOfDay(for: date)
			let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

			predicates.append(NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, endOfDay as CVarArg))
		}

		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		return request
	}
}
