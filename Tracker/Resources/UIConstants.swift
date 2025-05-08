//
//  UIConstants.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

import UIKit



enum UIConstants {
	static let elementSize: CGFloat = {
		let screenWidth = UIScreen.main.bounds.width

		if screenWidth <= 375 {
			return 48
		} else {
			return 52
		}
	}()

	static let inset: CGFloat = {
		print(UIScreen.main.bounds.width)
		let screenWidth = UIScreen.main.bounds.width

		if screenWidth <= 375 {
			return 16
		} else {
			return 18
		}
	}()
}
