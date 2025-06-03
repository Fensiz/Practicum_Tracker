//
//  TrackerRepository.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 09.05.2025.
//

import CoreData

final class TrackerRepository: NSObject, TrackerRepositoryProtocol {

	// MARK: - Private Stores

	private let context: NSManagedObjectContext

	private let trackerStore: TrackerStore
	private let categoryStore: TrackerCategoryStore
	private let recordStore: TrackerRecordStore
	weak var delegate: TrackersPresenterDelegate!

	private var fetchedResultsController: NSFetchedResultsController<TrackerCDEntity>?

	// MARK: - Init

	init(context: NSManagedObjectContext) {
		self.context = context
		self.trackerStore = TrackerStore(context: context)
		self.categoryStore = TrackerCategoryStore(context: context)
		self.recordStore = TrackerRecordStore(context: context)
	}

	// MARK: - Trackers

	func visibleTrackers(searchText: String) -> [TrackerCategory] {
		guard let sections = fetchedResultsController?.sections else { return [] }

		var pinned: [Tracker] = []

		var notPinnedCategories: [TrackerCategory] = sections.compactMap { section in
			guard let trackerEntities = section.objects as? [TrackerCDEntity] else { return nil }

			let trackers = trackerEntities
				.compactMap { trackerStore.tracker(from: $0) }
				.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }

			let pinnedTrackers = trackers.filter { $0.isPinned }
			let notPinnedTrackers = trackers.filter { !$0.isPinned }

			if !pinnedTrackers.isEmpty {
				pinned += pinnedTrackers
			}

			guard !notPinnedTrackers.isEmpty else { return nil }

			return TrackerCategory(title: section.name, trackers: notPinnedTrackers)
		}
		if !pinned.isEmpty {
			notPinnedCategories.insert(.init(title: String(localized: "Pinned"), trackers: pinned), at: 0)
		}

		return notPinnedCategories
	}

	func isDayHasTrackers(_ date: Date) -> Bool {
		let request = TrackerCDEntity.fetchRequest()

		let calendar = Calendar.current
		let startOfDay = calendar.startOfDay(for: date)
		guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
			return false
		}
		let weekdayRaw = WeekDay.from(date: date).rawValue

		let schedulePredicate = NSPredicate(format: "schedule CONTAINS %@", "\(weekdayRaw)")
		let datePredicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, nextDay as CVarArg)

		request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [schedulePredicate, datePredicate])
		request.fetchLimit = 1

		do {
			let count = try context.count(for: request)
			return count > 0
		} catch {
			print("Failed to count trackers for date \(date): \(error)")
			return false
		}
	}

	func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
		let categoryEntity = try categoryStore.getOrCreateCategoryEntity(for: category)
		try trackerStore.add(tracker, to: categoryEntity)

		try saveContext()
	}


	func updateTracker(_ tracker: Tracker, in newCategory: TrackerCategory) throws {
		let trackerCDEntity = try trackerStore.fetchEntity(by: tracker.id)

		trackerCDEntity.name = tracker.name
		trackerCDEntity.emoji = tracker.emoji
		trackerCDEntity.colorHex = tracker.color.toHex()
		trackerCDEntity.schedule = tracker.scheduleString
		trackerCDEntity.isPinned = tracker.isPinned

		if trackerCDEntity.category?.title != newCategory.title {
			let newCategoryEntity = try categoryStore.getOrCreateCategoryEntity(for: newCategory)
			trackerCDEntity.category = newCategoryEntity
		}

		try saveContext()
	}

	func deleteTracker(id: UUID) throws {
		try trackerStore.delete(id)
		
		try saveContext()
	}

	func togglePinnedTracker(id: UUID) throws {
		let trackerCDEntity = try trackerStore.fetchEntity(by: id)
		trackerCDEntity.isPinned.toggle()

		try saveContext()
	}

	// MARK: - Categories

	func fetchAllCategories() -> [TrackerCategory] {
		do {
			let categoryEntities = try categoryStore.fetchAll()
			return categoryEntities.compactMap { entity in
				guard let title = entity.title else { return nil }
				let trackerEntities = entity.trackers as? Set<TrackerCDEntity> ?? []
				let trackers = trackerEntities.compactMap { trackerStore.tracker(from: $0) }
				return TrackerCategory(title: title, trackers: trackers)
			}
		} catch {
			print("⚠️ Failed to fetch categories: \(error)")
			return []
		}
	}

	func getCategory(by title: String) throws -> TrackerCategory? {
		let category = try categoryStore.getOrCreateCategoryEntity(for: title)
		return self.category(from: category)
	}

	private func category(from entity: TrackerCategoryCDEntity) -> TrackerCategory? {
		guard let title = entity.title else { return nil }

		let trackers: [Tracker] = (entity.trackers as? Set<TrackerCDEntity>)?.compactMap {
			trackerStore.tracker(from: $0)
		} ?? []

		return TrackerCategory(title: title, trackers: trackers)
	}

	func addCategory(_ category: TrackerCategory) throws {
		_ = try categoryStore.getOrCreateCategoryEntity(for: category)

		try saveContext()
	}

	func deleteCategory(_ category: TrackerCategory) throws {
		let categoryEntity = try categoryStore.getOrCreateCategoryEntity(for: category)

		trackerStore.deleteTrackers(in: categoryEntity)
		categoryStore.delete(categoryEntity)

		try saveContext()
	}

	// MARK: - Records

	func toggleRecord(for trackerID: UUID, on date: Date) throws {
		let record = TrackerRecord(id: trackerID, date: date)
		if try recordStore.contains(record) {
			try recordStore.delete(record: record)
		} else {
			try recordStore.add(record: record)
		}
	}

	func isTrackerCompleted(_ trackerID: UUID, on date: Date) throws -> Bool {
		let record = TrackerRecord(id: trackerID, date: date)
		return try recordStore.contains(record)
	}

	func completedCount(for trackerID: UUID) throws -> Int {
		try recordStore.completedCount(for: trackerID)
	}

	func editCategoryTitle(from old: TrackerCategory, to newTitle: String) throws {
		let entity = try categoryStore.getOrCreateCategoryEntity(for: old)
		entity.title = newTitle
		try saveContext()
	}

	func startObservingTrackers(for date: Date, completed: Bool? = nil) {
		let frc = trackerStore.makeFetchedResultsController(for: date, completed: completed)
		fetchedResultsController = frc
		frc.delegate = self

		do {
			try frc.performFetch()
			self.delegate?.trackerStoreDidChangeContent()
		} catch {
			print("❌ Failed to fetch trackers: \(error)")
		}
	}

	// MARK: - Private Methods

	private func saveContext() throws {
		if context.hasChanges {
			try context.save()
		}
	}
}

extension TrackerRepository: NSFetchedResultsControllerDelegate {
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		delegate?.trackerStoreDidChangeContent()
	}
}

extension TrackerRepository: TrackerRepositoryStatsProtocol {
	func containAnyTracker() -> Bool {
		trackerStore.hasAnyTracker()
	}

	func trackersCompletedAllTime() -> Int {
		(try? recordStore.fetchAll().count) ?? 0
	}

	func countOfFullCompletionDays() -> Int {
		let calendar = Calendar.current

		// Все трекеры
		let trackerModels = trackerStore.fetchAllTrackers()

		// Все записи
		let records = recordStore.fetchAllRecords()

		// Группируем по дате
		let groupedByDayRecords = Dictionary(grouping: records) { record in
			calendar.startOfDay(for: record.date)
		}

		var completedDaysCount = 0

		for (day, recordsForDay) in groupedByDayRecords {
			// 1. Актуальные трекеры на эту дату
			let activeTrackersForDate = trackerModels.filter { tracker in
				if let schedule = tracker.schedule {
					let weekday = WeekDay.from(date: day)
					return schedule.contains(weekday)
				} else if let date = tracker.date {
					// Для нерегулярных — сравнение по дате
					return calendar.isDate(day, inSameDayAs: date)
				}
				return false
			}

			// 2. Завершённые трекеры в эту дату
			let completedTrackers = Set(recordsForDay.compactMap { $0.id })

			// 3. Проверка: все ли активные трекеры завершены
			let activeIDs = Set(activeTrackersForDate.map { $0.id })
			if activeIDs.isSubset(of: completedTrackers), !activeIDs.isEmpty {
				completedDaysCount += 1
			}
		}

		return completedDaysCount
	}
}
