//
//  Weekday.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 21.04.2025.
//

import Foundation

enum WeekDay: Int, CaseIterable, Codable {
	case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

	static func from(date: Date) -> WeekDay {
		let calendar = Calendar.current
		let component = calendar.component(.weekday, from: date)
		// Sunday = 1, Monday = 2, ... (в Calendar)
		return WeekDay(rawValue: component == 1 ? 7 : component - 1)! // так получаем понедельник первым
	}

	var title: String {
		switch self {
			case .monday: "Понедельник"
			case .tuesday: "Вторник"
			case .wednesday: "Среда"
			case .thursday: "Четверг"
			case .friday: "Пятница"
			case .saturday: "Суббота"
			case .sunday: "Воскресенье"
		}
	}
	var short: String {
		switch self {
			case .monday: "Пн"
			case .tuesday: "Вт"
			case .wednesday: "Ср"
			case .thursday: "Чт"
			case .friday: "Пт"
			case .saturday: "Сб"
			case .sunday: "Вс"
		}
	}
}
