//
//  NewCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

protocol NewCategoryViewControllerDelegate: AnyObject {
	func categoryExists(with title: String) -> Bool
}
