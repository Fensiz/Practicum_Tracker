//
//  TrackerSnapshotTests.swift
//  TrackerSnapshotTests
//
//  Created by Симонов Иван Дмитриевич on 03.06.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
	func testMainScreen() {
		let presenter = StubTrackersPresenter(
			visibleTrackers: [
				.init(
					title: "Some category",
					trackers: [
						.init(
							id: UUID(),
							name: "SomeName",
							color: .grRed,
							emoji: "❤️",
							schedule: nil,
							date: Date(timeIntervalSince1970: 0),
							isPinned: false
						)
					]
				)
			]
		)
		presenter.completedCountProp = 20
		let sut = TrackersViewController(presenter: presenter)

		assertSnapshot(of: sut, as: .image(traits: .init(userInterfaceStyle: .light)), named: "light")
		assertSnapshot(of: sut, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "dark")
	}

	func testMainScreenWithEmptyData() {
		let presenter = StubTrackersPresenter(visibleTrackers: [])
		let sut = TrackersViewController(presenter: presenter)
		
		assertSnapshot(of: sut, as: .image)
	}
}
