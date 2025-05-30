//
//  Tracker 2.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 21.04.2025.
//

import UIKit

struct Tracker {
	let id: UUID
	let name: String
	let color: UIColor
	let emoji: String
	let schedule: Set<WeekDay>?
	let date: Date?
	let isPinned: Bool

	var scheduleString: String? {
		guard let schedule else { return nil }
		return schedule.map { "\($0.rawValue)" }.joined(separator: ",")
	}

	init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Set<WeekDay>?, date: Date?, isPinned: Bool) {
		self.id = id
		self.name = name
		self.color = color
		self.emoji = emoji
		self.schedule = schedule
		self.date = date
		self.isPinned = isPinned
	}

	init(name: String, color: UIColor, emoji: String, schedule: Set<WeekDay>? = nil, date: Date? = nil, isPinned: Bool) {
		self.id = UUID()
		self.name = name
		self.color = color
		self.emoji = emoji
		self.schedule = schedule
		self.date = date
		self.isPinned = isPinned
	}

	init(tracker: Tracker) {
		self.id = tracker.id
		self.name = tracker.name
		self.color = tracker.color
		self.emoji = tracker.emoji
		self.schedule = tracker.schedule
		self.date = tracker.date
		self.isPinned = tracker.isPinned
	}

	func togglePinned() -> Self {
		Tracker(
			id: self.id,
			name: self.name,
			color: self.color,
			emoji: self.emoji,
			schedule: self.schedule,
			date: self.date,
			isPinned: !self.isPinned
		)
	}
}
