//
//  CollectionBlock.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit

enum CollectionBlock {
	case textField
	case trackerOptions([TrackerOption])
	case emoji([String])
	case color([UIColor])

	var name: String {
		switch self {
		case .textField, .trackerOptions:
			return ""
		case .emoji:
			return "Emoji"
		case .color:
			return "Цвет"
		}
	}

	var itemsCount: Int {
		switch self {
		case .textField, .trackerOptions:
			return 1
		case .emoji(let emojis):
			return emojis.count
		case .color(let colors):
			return colors.count
		}
	}
}
