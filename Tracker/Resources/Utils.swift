//
//  Utils.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 31.05.2025.
//

enum Utils {
	static func daysText(_ count: Int) -> String {
		let daysText: String
		let lastTwoDigits = count % 100
		let lastDigit = count % 10

		if (11...14).contains(lastTwoDigits) {
			daysText = String(localized: "moreDays") // дней
		} else {
			switch lastDigit {
				case 1: daysText = String(localized: "oneDay") // день
				case 2...4: daysText = String(localized: "twoDays") // дня
				default: daysText = String(localized: "moreDays") // дней
			}
		}
		return "\(count) \(daysText)"
	}
}
