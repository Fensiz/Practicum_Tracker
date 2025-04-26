//
//  TrackerCategory.swift.swift
//  TrackerCategory.swift
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

struct TrackerCategory: Equatable {
	static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
		lhs.title == rhs.title
	}
	
	let title: String
	let trackers: [Tracker]
}
