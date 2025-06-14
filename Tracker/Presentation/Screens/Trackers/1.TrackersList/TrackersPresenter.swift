//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit


final class TrackersPresenter: TrackersPresenterProtocol {

	// MARK: - Properties

	private(set) var repository: TrackerRepository

	private(set) var currentDate: Date {
		didSet {
			repository.startObservingTrackers(for: currentDate)
		}
	}

	private var searchText: String = "" {
		didSet {
			onChange?()
		}
	}

	var onChange: (() -> Void)?

	var isTrackerActionEnabled: Bool {
		!(Calendar.current.startOfDay(for: currentDate) > Calendar.current.startOfDay(for: Date()))
	}

	var visibleTrackers: [TrackerCategory] {
		repository.visibleTrackers(searchText: searchText)
	}

	// MARK: - Init

	init(repository: TrackerRepository) {
		self.repository = repository
		self.currentDate = Date()
		self.repository.startObservingTrackers(for: currentDate)
	}

	// MARK: - Public methods

	func updateDate(_ date: Date) {
		currentDate = date
	}

	func updateSearchText(_ text: String) {
		searchText = text
		onChange?()
	}

	func toggleCompletion(for tracker: Tracker) {
		do {
			try repository.toggleRecord(for: tracker.id, on: currentDate)
			onChange?()
		} catch {
			print("⚠️ Ошибка при переключении записи: \(error)")
		}
	}

	func isTrackerCompleted(_ tracker: Tracker) -> Bool {
		(doTry { try repository.isTrackerCompleted(tracker.id, on: currentDate) }) ?? false
	}

	func completedCount(for tracker: Tracker) -> Int {
		(doTry { try repository.completedCount(for: tracker.id) }) ?? 0
	}

	func fetchCategories() -> [TrackerCategory] {
		repository.fetchAllCategories()
	}

	func deleteTracker(_ tracker: Tracker) {
		do {
			try repository.deleteTracker(id: tracker.id)
		} catch {
			print("⚠️ Ошибка при удалении трекера: \(error)")
		}
	}

	private func doTry<T>(_ block: () throws -> T) -> T? {
		do {
			return try block()
		} catch {
			print("⚠️ Ошибка: \(error)")
			return nil
		}
	}
}

extension TrackersPresenter: TrackersPresenterDelegate {
	func trackerStoreDidChangeContent() {
		onChange?()
	}
}
