//
//  CategorySelectionPresenter.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 09.05.2025.
//

import Foundation

protocol CategorySelectionViewProtocol: AnyObject {
	func performBatchUpdate(insert: [Int], delete: [Int], reload: [Int])
	func updateCategories(_ categories: [TrackerCategory])
	func showError(_ message: String)
	func dismissView()
}

final class CategorySelectionPresenter: CategorySelectionPresenterProtocol {
	weak var delegate: CategorySelectionDelegate?
	weak var view: CategorySelectionViewProtocol?

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
		categories.contains { $0.title.caseInsensitiveCompare(title) == .orderedSame }
	}

	func addCategory(title: String) {
		let newCategory = TrackerCategory(title: title, trackers: [])

		do {
			try repository.addCategory(newCategory)

			let updatedCategories = repository.fetchAllCategories()

			guard let index = updatedCategories.firstIndex(where: { $0.title == title }) else {
				categories = updatedCategories
				view?.updateCategories(categories)
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

			view?.performBatchUpdate(
				insert: [index],
				delete: [],
				reload: reload
			)
		} catch {
			view?.showError("Не удалось добавить категорию")
		}
	}

	func deleteCategory(at index: Int) {
		let category = categories[index]
		do {
			try repository.deleteCategory(category)

			// Определим, нужно ли перерисовать предыдущую ячейку ПЕРЕД удалением
			let reload = (index > 0 && index == categories.count - 1) ? [index - 1] : []

			categories.remove(at: index)

			view?.performBatchUpdate(
				insert: [],
				delete: [index],
				reload: reload
			)

			if selectedCategory == category {
				selectedCategory = nil
			}
		} catch {
			view?.showError("Не удалось удалить категорию")
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

			view?.updateCategories(categories)
		} catch {
			view?.showError("Не удалось изменить категорию")
		}
	}

	func didSelectCategory(at index: Int) {
		let selected = categories[index]
		delegate?.didSelectCategory(selected, [])
		view?.dismissView()
	}

	private func fetchCategories() {
		categories = repository.fetchAllCategories()
	}
}
