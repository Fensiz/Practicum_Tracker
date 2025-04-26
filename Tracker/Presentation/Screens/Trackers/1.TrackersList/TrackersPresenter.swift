//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//


import UIKit

final class TrackersPresenter: TrackersPresenterProtocol {

	// MARK: - Properties

	private(set) var categories: [TrackerCategory] {
		didSet {
			onChange?()
		}
	}
	private var completedTrackers: Set<TrackerRecord>
	private var currentDate: Date {
		didSet {
			onChange?()
		}
	}

	private var searchText: String = "" {
		didSet {
			onChange?()
		}
	}

	var onChange: (() -> Void)?

	var visibleTrackers: [TrackerCategory] {
		let currentWeekDay = WeekDay.from(date: currentDate)

		return categories.compactMap { category in
			let filteredTrackers = category.trackers.filter { tracker in
				let matchesSchedule: Bool
				if let schedule = tracker.schedule {
					matchesSchedule = schedule.contains(currentWeekDay)
				} else {
					matchesSchedule = true
				}

				let matchesSearch: Bool
				if searchText.isEmpty {
					matchesSearch = true
				} else {
					matchesSearch = tracker.name.lowercased().contains(searchText.lowercased())
				}

				return matchesSchedule && matchesSearch
			}
			return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
		}
	}

	// MARK: - Init

	init() {
		self.categories = [
			TrackerCategory(
				title: "Домашний уют",
				trackers: [Tracker(
					name: "Поливать растения",
					color: .systemTeal,
					emoji: "😊",
					schedule: [.friday]
				)]
			),
			TrackerCategory(
				title: "Радостные мелочи",
				trackers: [Tracker(
					name: "Кошка заслонила камеру на созвоне",
					color: .ypRed,
					emoji: "😊",
					schedule: [.friday]
				)]
			)
		]
		self.completedTrackers = []
		self.currentDate = Date()
	}

	// MARK: - Public methods

	func updateDate(_ date: Date) {
		currentDate = date
	}

	func toggleCompletion(for tracker: Tracker) {
		let record = TrackerRecord(id: tracker.id, date: currentDate)
		if completedTrackers.contains(record) {
			completedTrackers.remove(record)
		} else {
			completedTrackers.insert(record)
		}
	}

	func isTrackerCompleted(_ tracker: Tracker) -> Bool {
		completedTrackers.contains {
			$0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
		}
	}

	func completedCount(for tracker: Tracker) -> Int {
		completedTrackers.filter { $0.id == tracker.id }.count
	}

	func updateCategories(_ categories: [TrackerCategory]) {
		self.categories = categories
	}

	func updateSearchText(_ text: String) {
		 self.searchText = text
	}
}
