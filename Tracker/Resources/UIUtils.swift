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

	static func makeDeleteConfirmationAlert(message: String, action: @escaping () -> ()) -> UIAlertController {
		let alert = UIAlertController(
			title: nil,
			message: String(localized: String.LocalizationValue(message)),
			preferredStyle: .actionSheet
		)

		let deleteAction = UIAlertAction(
			title: String(localized: "Delete"),
			style: .destructive
		) { _ in
			action()
		}

		let cancelAction = UIAlertAction(
			title: String(localized: "Cancel"),
			style: .cancel
		)

		alert.addAction(deleteAction)
		alert.addAction(cancelAction)

		return alert
	}
}
