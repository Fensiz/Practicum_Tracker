//
//  NewCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

protocol CategoryViewControllerDelegate: AnyObject {
	func categoryExists(with title: String) -> Bool
	func didAddNewCategory(with title: String)
	func didEditCategory(with oldTitle: String, newTitle: String)
}
