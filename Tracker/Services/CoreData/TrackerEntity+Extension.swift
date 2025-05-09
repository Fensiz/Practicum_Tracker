//
//  Extension+TrackerEntity.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

import Foundation

extension TrackerEntity {
	var scheduleSet: Set<WeekDay> {
		(try? JSONDecoder().decode(Set<WeekDay>.self, from: schedule ?? Data())) ?? []
	}
}
