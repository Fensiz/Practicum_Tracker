//
//  CategorySelectionDelegate.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//


protocol CategorySelectionDelegate: AnyObject {
	func didSelectCategory(_ category: TrackerCategory, _ categories: [TrackerCategory])
}