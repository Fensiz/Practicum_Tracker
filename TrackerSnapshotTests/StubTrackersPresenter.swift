//
//  StubTrackersPresenter.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 05.06.2025.
//

@testable import Tracker
import Foundation

final class StubTrackersPresenter: TrackersPresenterProtocol {
	var onChange: (() -> Void)?
	var onChangeDate: ((Date) -> Void)?
	var visibleTrackers: [TrackerCategory]
	var currentDate: Date
	var isTrackerActionEnabled: Bool
	var repository: any TrackerRepositoryProtocol
	var searchText: String
	var filter: Option
	var isDayHasTrackers: Bool

	var completedCountProp: Int = 0

	init(
		onChange: (() -> Void)? = nil,
		onChangeDate: ((Date) -> Void)? = nil,
		visibleTrackers: [TrackerCategory] = [],
		currentDate: Date = Date(timeIntervalSince1970: 0),
		isTrackerActionEnabled: Bool = true,
		repository: any TrackerRepositoryProtocol = DummyRepository(),
		searchText: String = "",
		filter: Option = .allTrackers,
		isDayHasTrackers: Bool = true
	) {
		self.onChange = onChange
		self.onChangeDate = onChangeDate
		self.visibleTrackers = visibleTrackers
		self.currentDate = currentDate
		self.isTrackerActionEnabled = isTrackerActionEnabled
		self.repository = repository
		self.searchText = searchText
		self.filter = filter
		self.isDayHasTrackers = isDayHasTrackers
	}

	func updateDate(_ date: Date) {
		fatalError(#function)
	}

	func toggleCompletion(for tracker: Tracker) {
		fatalError(#function)
	}

	func isTrackerCompleted(_ tracker: Tracker) -> Bool {
		true
	}

	func completedCount(for tracker: Tracker) -> Int {
		completedCountProp
	}

	func updateSearchText(_ text: String) {
		fatalError(#function)
	}

	func deleteTracker(_ tracker: Tracker) {
		fatalError(#function)
	}

	func togglePinned(for: Tracker) {
		fatalError(#function)
	}

	func didSelectFilterOption(_ option: Option) {
		fatalError(#function)
	}
}
