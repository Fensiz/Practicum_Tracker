//
//  TrackerRepositoryProtocol.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 10.05.2025.
//

import CoreData

protocol TrackerRepositoryProtocol {
//	func makeFetchedResultsController(for date: Date) -> NSFetchedResultsController<TrackerEntity>
	func visibleTrackers(searchText: String) -> [TrackerCategory]
	func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws
	func deleteTracker(id: UUID) throws
	func fetchAllCategories() -> [TrackerCategory]
	func addCategory(_ category: TrackerCategory) throws
	func deleteCategory(_ category: TrackerCategory) throws
	func toggleRecord(for trackerID: UUID, on date: Date) throws
	func isTrackerCompleted(_ trackerID: UUID, on date: Date) throws -> Bool
	func completedCount(for trackerID: UUID) throws -> Int
	func getCategory(by title: String) throws -> TrackerCategory?
	func editCategoryTitle(from old: TrackerCategory, to newTitle: String) throws
	func updateTracker(_ tracker: Tracker, in newCategory: TrackerCategory) throws
	func startObservingTrackers(for date: Date)
	func togglePinnedTracker(id: UUID) throws
}
