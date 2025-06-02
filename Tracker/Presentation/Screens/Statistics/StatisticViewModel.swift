//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 02.06.2025.
//

struct StatisticItem {
	let name: String
	let value: () -> Int
}

final class StatisticViewModel {

	lazy var statistics: [StatisticItem] = [
		.init(name: "Идеальные дни", value: completedDays),
		.init(name: "Трекеров завершено", value: trackersCompleted),
	]

	private let repository: TrackerRepositoryStatsProtocol

	init(repository: TrackerRepositoryStatsProtocol) {
		self.repository = repository
	}

	func containTrackers() -> Bool {
		repository.containAnyTracker()
	}

	func completedDays() -> Int {
		0
	}

	func trackersCompleted() -> Int {
		repository.trackersCompletedAllTime()
	}
}
