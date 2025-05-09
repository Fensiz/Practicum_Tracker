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
		let entity = TrackerRecordEntity(context: context)
		entity.id = record.id
		entity.date = record.date
		try context.save()
	}

	func delete(record: TrackerRecord) throws {
		let request = fetchRequest(for: record.id, date: record.date)
		if let object = try context.fetch(request).first {
			context.delete(object)
			try context.save()
		}
	}

	func recordExists(trackerID: UUID, date: Date) throws -> Bool {
		let request = fetchRequest(for: trackerID, date: date)
		let count = try context.count(for: request)
		return count > 0
	}

	func fetchAll() throws -> [TrackerRecord] {
		let request = TrackerRecordEntity.fetchRequest()
		let result = try context.fetch(request)
		return result.compactMap { record(from: $0) }
	}

	private func record(from entity: TrackerRecordEntity) -> TrackerRecord? {
		guard let id = entity.id,
			  let date = entity.date else {
			return nil
		}
		return TrackerRecord(id: id, date: date)
	}

	private func fetchRequest(for trackerID: UUID, date: Date) -> NSFetchRequest<TrackerRecordEntity> {
		let request = TrackerRecordEntity.fetchRequest()
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			NSPredicate(format: "id == %@", trackerID as CVarArg),
			NSPredicate(format: "date == %@", date as CVarArg)
		])
		return request
	}
}
