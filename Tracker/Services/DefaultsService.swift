//
//  UDService.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.05.2025.
//

import Foundation

enum DefaultsService {
	static var isFirstLaunch: Bool {
		get {
			!UserDefaults.standard.bool(forKey: "isNotFirstLaunch")
		}
		set {
			UserDefaults.standard.set(!newValue, forKey: "isNotFirstLaunch")
		}
	}
}
