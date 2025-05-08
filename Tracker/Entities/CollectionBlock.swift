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
			case .textField, .trackerOptions: ""
			case .emoji: "Emoji"
			case .color: "Цвет"
		}
	}

	var itemsCount: Int {
		switch self {
			case .textField, .trackerOptions: 1
			case .emoji(let emojis): emojis.count
			case .color(let colors): colors.count
		}
	}
}
