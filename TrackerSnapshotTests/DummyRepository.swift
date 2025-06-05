//
//  DummyRepository.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 05.06.2025.
//

@testable import Tracker
import Foundation

final class DummyRepository: TrackerRepositoryProtocol {
	func visibleTrackers(searchText: String) -> [TrackerCategory] {
		fatalError(#function)
	}
	
	func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
		fatalError(#function)
	}
	
	func deleteTracker(id: UUID) throws {
		fatalError(#function)
	}
	
	func fetchAllCategories() -> [TrackerCategory] {
		fatalError(#function)
	}
	
	func addCategory(_ category: TrackerCategory) throws {
		fatalError(#function)
	}
	
	func deleteCategory(_ category: TrackerCategory) throws {
		fatalError(#function)
	}
	
	func toggleRecord(for trackerID: UUID, on date: Date) throws {
		fatalError(#function)
	}
	
	func isTrackerCompleted(_ trackerID: UUID, on date: Date) throws -> Bool {
		fatalError(#function)
	}
	
	func completedCount(for trackerID: UUID) throws -> Int {
		fatalError(#function)
	}
	
	func getCategory(by title: String) throws -> TrackerCategory? {
		fatalError(#function)
	}
	
	func editCategoryTitle(from old: TrackerCategory, to newTitle: String) throws {
		fatalError(#function)
	}
	
	func updateTracker(_ tracker: Tracker, in newCategory: TrackerCategory) throws {
		fatalError(#function)
	}
	
	func startObservingTrackers(for date: Date, completed: Bool?) {
		fatalError(#function)
	}
	
	func togglePinnedTracker(id: UUID) throws {
		fatalError(#function)
	}
	
	func isDayHasTrackers(_ date: Date) -> Bool {
		fatalError(#function)
	}
}
