//
//  TrackerRepositoryStatsProtocol.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 02.06.2025.
//

protocol TrackerRepositoryStatsProtocol {
	func containAnyTracker() -> Bool
	func trackersCompletedAllTime() -> Int
}
