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

	var scheduleString: String? {
		guard let schedule else { return nil }
		return schedule.map { "\($0.rawValue)" }.joined(separator: ",")
	}

	init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Set<WeekDay>?, date: Date?) {
		self.id = id
		self.name = name
		self.color = color
		self.emoji = emoji
		self.schedule = schedule
		self.date = date
	}

	init(name: String, color: UIColor, emoji: String, schedule: Set<WeekDay>? = nil, date: Date? = nil) {
		self.id = UUID()
		self.name = name
		self.color = color
		self.emoji = emoji
		self.schedule = schedule
		self.date = date
	}

	init(tracker: Tracker) {
		self.id = tracker.id
		self.name = tracker.name
		self.color = tracker.color
		self.emoji = tracker.emoji
		self.schedule = tracker.schedule
		self.date = tracker.date
	}
}
