//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

import UIKit

extension UIColor {
	func toHex(alpha: Bool = false) -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0

		getRed(&r, green: &g, blue: &b, alpha: &a)

		if alpha {
			return String(format: "#%02X%02X%02X%02X",
						  Int(r * 255),
						  Int(g * 255),
						  Int(b * 255),
						  Int(a * 255))
		} else {
			return String(format: "#%02X%02X%02X",
						  Int(r * 255),
						  Int(g * 255),
						  Int(b * 255))
		}
	}

	convenience init?(hex: String) {
		var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

		var rgb: UInt64 = 0
		guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

		let length = hexSanitized.count
		switch length {
		case 6:
			let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
			let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
			let b = CGFloat(rgb & 0x0000FF) / 255
			self.init(red: r, green: g, blue: b, alpha: 1.0)
		case 8:
			let r = CGFloat((rgb & 0xFF000000) >> 24) / 255
			let g = CGFloat((rgb & 0x00FF0000) >> 16) / 255
			let b = CGFloat((rgb & 0x0000FF00) >> 8) / 255
			let a = CGFloat(rgb & 0x000000FF) / 255
			self.init(red: r, green: g, blue: b, alpha: a)
		default:
			return nil
		}
	}
}
