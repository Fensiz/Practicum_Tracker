//
//  CategorySelectionPresenter.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 09.05.2025.
//

import Foundation

final class CategorySelectionViewModel {
	weak var delegate: CategorySelectionDelegate?

	var onUpdate: (() -> Void)?
	var onError: ((String) -> Void)?
	var onDismiss: (() -> Void)?
	var onBatchUpdate: ((_ insert: [Int], _ delete: [Int], _ reload: [Int]) -> Void)?

	var numberOfCategories: Int {
		categories.count
	}

	private let repository: TrackerRepositoryProtocol
	private(set) var selectedCategory: TrackerCategory?
	private var categories: [TrackerCategory] = []

	init(repository: TrackerRepositoryProtocol, selected: TrackerCategory?) {
		self.repository = repository
		self.selectedCategory = selected
	}

	func viewDidLoad() {
		fetchCategories()
	}

	func category(at index: Int) -> TrackerCategory {
		categories[index]
	}

	func categoryExists(with title: String) -> Bool {
		categories.contains { $0.title.caseInsensitiveCompare(title) == .orderedSame } || title == "Pinned" || title == "Закрепленные"
	}

	func addCategory(title: String) {
		let newCategory = TrackerCategory(title: title, trackers: [])

		do {
			try repository.addCategory(newCategory)

			let updatedCategories = repository.fetchAllCategories()

			guard let index = updatedCategories.firstIndex(where: { $0.title == title }) else {
				categories = updatedCategories
				onUpdate?()
				return
			}

			categories = updatedCategories

			// Перерисовать нужно следующую ячейку, если вставили НЕ в конец
			let reload: [Int]
			if index < categories.count - 1 {
				reload = [index + 1]
			} else if index > 0 {
				reload = [index - 1] // если вставили в конец — предыдущая теперь не последняя
			} else {
				reload = []
			}

			onBatchUpdate?(
				[index],	//insert
				[],			//delete
				reload		//reload
			)
		} catch {
			onError?("Не удалось добавить категорию")
		}
	}

	func deleteCategory(at index: Int) {
		let category = categories[index]
		do {
			try repository.deleteCategory(category)

			// Определим, нужно ли перерисовать предыдущую ячейку ПЕРЕД удалением
			let reload = (index > 0 && index == categories.count - 1) ? [index - 1] : []

			categories.remove(at: index)

			onBatchUpdate?(
				[],			//insert
				[index],	//delete
				reload		//reload
			)

			if selectedCategory == category {
				selectedCategory = nil
			}
		} catch {
			onError?("Не удалось удалить категорию")
		}
	}

	func editCategory(oldTitle: String, newTitle: String) {
		guard let index = categories.firstIndex(where: { $0.title == oldTitle }) else { return }
		let oldCategory = categories[index]

		do {
			try repository.editCategoryTitle(from: oldCategory, to: newTitle)

			let updated = TrackerCategory(title: newTitle, trackers: oldCategory.trackers)
			categories[index] = updated

			if selectedCategory == oldCategory {
				selectedCategory = updated
			}

			onUpdate?()
		} catch {
			onError?("Не удалось изменить категорию")
		}
	}

	func didSelectCategory(at index: Int) {
		let selected = categories[index]
		delegate?.didSelectCategory(selected, [])
		onDismiss?()
	}

	private func fetchCategories() {
		categories = repository.fetchAllCategories()
	}
}
