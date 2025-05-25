//
//  CategorySelectionPresenterProtocol.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 09.05.2025.
//


protocol CategorySelectionPresenterProtocol {
	var selectedCategory: TrackerCategory? { get }
	var numberOfCategories: Int { get }

	func viewDidLoad()
	func addCategory(title: String)
	func editCategory(oldTitle: String, newTitle: String)
	func deleteCategory(at index: Int)
	func categoryExists(with title: String) -> Bool
	func category(at index: Int) -> TrackerCategory
	func didSelectCategory(at index: Int)
}
