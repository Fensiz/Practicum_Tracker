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
	private(set) var completedTrackers: Set<TrackerRecord>
	private(set) var currentDate: Date {
		didSet {
			onChange?()
		}
	}

	var onChange: (() -> Void)?

	var visibleTrackers: [TrackerCategory] {
		let currentWeekDay = WeekDay.from(date: currentDate)

		return categories.compactMap { category in
			let trackersForDay = category.trackers.filter { tracker in
				guard let schedule = tracker.schedule else { return true }
				return schedule.contains(currentWeekDay)
			}
			return trackersForDay.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackersForDay)
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
}
