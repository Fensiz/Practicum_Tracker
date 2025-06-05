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

		return sections.compactMap { section in
			guard let trackerEntities = section.objects as? [TrackerCDEntity] else { return nil }

			let trackers = trackerEntities
				.compactMap { trackerStore.tracker(from: $0) }
				.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }

			guard !trackers.isEmpty else { return nil }

			return TrackerCategory(title: section.name, trackers: trackers)
		}
	}

	func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
		let categoryEntity = try categoryStore.getOrCreateCategoryEntity(for: category)
		try trackerStore.add(tracker, to: categoryEntity)

		try saveContext()
	}


	func updateTracker(_ tracker: Tracker, in newCategory: TrackerCategory) throws {
		let TrackerCDEntity = try trackerStore.fetchEntity(by: tracker.id)

		TrackerCDEntity.name = tracker.name
		TrackerCDEntity.emoji = tracker.emoji
		TrackerCDEntity.colorHex = tracker.color.toHex()
		TrackerCDEntity.schedule = tracker.scheduleString

		if TrackerCDEntity.category?.title != newCategory.title {
			let newCategoryEntity = try categoryStore.getOrCreateCategoryEntity(for: newCategory)
			TrackerCDEntity.category = newCategoryEntity
		}

		try saveContext()
	}

	func deleteTracker(id: UUID) throws {
		try trackerStore.delete(id)
		
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

	func startObservingTrackers(for date: Date) {
		let frc = trackerStore.makeFetchedResultsController(for: date)
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
