//
//  TrackerTypeSelectionDelegate.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit

protocol TrackerTypeSelectionDelegate: AnyObject {
	func didSelectTrackerType(_ type: TrackerType, vc: UIViewController)
}
