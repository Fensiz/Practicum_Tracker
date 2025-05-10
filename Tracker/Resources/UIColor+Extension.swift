//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 08.05.2025.
//

import UIKit

extension UIColor {
	func toHex() -> String {
		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		getRed(&r, green: &g, blue: &b, alpha: &a)
		let rgb = (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)
		return String(format: "#%06X", rgb)
	}

	convenience init?(hex: String) {
		var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		if hex.hasPrefix("#") {
			hex.removeFirst()
		}

		guard let int = Int(hex, radix: 16) else { return nil }

		let r = CGFloat((int >> 16) & 0xFF) / 255.0
		let g = CGFloat((int >> 8) & 0xFF) / 255.0
		let b = CGFloat(int & 0xFF) / 255.0

		self.init(red: r, green: g, blue: b, alpha: 1.0)
	}
}
