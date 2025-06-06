//
//  TrackerOption.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//

import UIKit

struct TrackerOption {
	let title: String
	var value: String?
	let controllerProvider: () -> UIViewController

	init(title: String, value: String? = nil, controllerProvider: @escaping () -> UIViewController) {
		self.title = String(localized: String.LocalizationValue(title))
		self.value = value
		self.controllerProvider = controllerProvider
	}
}
