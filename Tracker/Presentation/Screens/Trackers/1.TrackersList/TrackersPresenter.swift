//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit


final class TrackersPresenter: TrackersPresenterProtocol {

	// MARK: - Properties

	private(set) var repository: TrackerRepositoryProtocol

	private(set) var currentDate: Date {
		didSet {
			onChangeDate?(currentDate)
			applyFilter()
		}
	}

	private(set) var filter: Option = .allTrackers {
		didSet {
			if filter == .todayTrackers {
				currentDate = Date()
			} else {
				applyFilter()
			}
		}
	}


	private func applyFilter() {
		let calendar = Calendar.current
		var isCompleted: Bool?

		switch filter {
			case .allTrackers:
				isCompleted = nil

			case .todayTrackers:
				if !calendar.isDate(currentDate, inSameDayAs: Date()) {
					filter = .allTrackers
					return
				}
				isCompleted = nil

			case .completed:
				isCompleted = true

			case .uncompleted:
				isCompleted = false
		}

		repository.startObservingTrackers(for: currentDate, completed: isCompleted)
	}

	private(set) var searchText: String = "" {
		didSet {
			onChange?()
		}
	}

	var onChange: (() -> Void)?
	var onChangeDate: ((Date) -> Void)?

	var isTrackerActionEnabled: Bool {
		!(Calendar.current.startOfDay(for: currentDate) > Calendar.current.startOfDay(for: Date()))
	}

	var visibleTrackers: [TrackerCategory] {
		repository.visibleTrackers(searchText: searchText)
	}

	var isDayHasTrackers: Bool {
		repository.isDayHasTrackers(currentDate)
	}

	// MARK: - Init

	init(repository: TrackerRepository) {
		self.repository = repository
		self.currentDate = Date()
		self.repository.startObservingTrackers(for: currentDate, completed: nil)
	}

	// MARK: - Public methods

	func updateDate(_ date: Date) {
		currentDate = date
	}

	func updateSearchText(_ text: String) {
		searchText = text
	}

	func togglePinned(for tracker: Tracker) {
		do {
			try repository.togglePinnedTracker(id: tracker.id)
			onChange?()
		} catch {
			print("⚠️ Ошибка при переключении записи: \(error)")
		}
	}

	func toggleCompletion(for tracker: Tracker) {
		AnalyticsService.logEvent(.click, screen: .main, item: .track)
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

extension TrackersPresenter: FilterOptionSelectionDelegate {
	func didSelectFilterOption(_ option: Option) {
		filter = option
	}
}
