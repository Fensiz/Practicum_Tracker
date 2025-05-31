//
//  Utils.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 31.05.2025.
//

enum Utils {
	static func daysText(_ count: Int) -> String {
		let daysText: String
		switch count {
			case 1: daysText = String(localized: "oneDay")
			case 2...4: daysText = String(localized: "twoDays")
			default: daysText = String(localized: "moreDays")
		}
		return "\(count) \(daysText)"
	}
}
