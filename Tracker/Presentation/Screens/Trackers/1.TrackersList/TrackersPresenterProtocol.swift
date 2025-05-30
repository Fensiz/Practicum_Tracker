//
//  TrackerPresenterProtocol.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import Foundation

protocol TrackersPresenterProtocol {
	var onChange: (() -> Void)? { get set }
	var visibleTrackers: [TrackerCategory] { get }
	var currentDate: Date { get }
	var isTrackerActionEnabled: Bool { get }
	var repository: TrackerRepository { get }
	var searchText: String { get }

	func fetchCategories() -> [TrackerCategory]
	func updateDate(_ date: Date)
	func toggleCompletion(for tracker: Tracker)
	func isTrackerCompleted(_ tracker: Tracker) -> Bool
	func completedCount(for tracker: Tracker) -> Int
	func updateSearchText(_ text: String)
	func deleteTracker(_ tracker: Tracker)
	func togglePinned(for: Tracker)
}
