//
//  Utils.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 10.05.2025.
//

import UIKit

enum UIUtils {
	static func findTextField(in view: UIView) -> UITextField? {
		for subview in view.subviews {
			if let textField = subview as? UITextField {
				return textField
			}
			if let found = findTextField(in: subview) {
				return found
			}
		}
		return nil
	}
	static func findCompactBackgroundView(in view: UIView) -> UIView? {
		for subview in view.subviews {
			if NSStringFromClass(type(of: subview)).contains("Compact") {
				return subview
			}
			if let found = findCompactBackgroundView(in: subview) {
				return found
			}
		}
		return nil
	}
	static func printAllSubviews(of view: UIView, depth: Int = 0) {
		let indent = String(repeating: "  ", count: depth)
		for subview in view.subviews {
			print("\(indent)- \(type(of: subview))")
			printAllSubviews(of: subview, depth: depth + 1)
		}
	}
}
