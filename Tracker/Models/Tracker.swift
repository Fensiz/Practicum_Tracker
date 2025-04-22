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
}
