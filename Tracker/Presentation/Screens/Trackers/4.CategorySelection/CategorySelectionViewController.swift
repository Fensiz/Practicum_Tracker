//
//  CategorySelectionViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//

import UIKit

final class CategorySelectionViewController: BaseViewController {
	
	// MARK: - Properties
	
	private let tableView = UITableView()
	private let emptyView = TrackersEmptyView(text: "Привычки и события можно объединить по смыслу")
	private let addButton = AppButton(title: "Добавить категорию")
	
	private var selectedCategory: TrackerCategory?
	private var tableViewHeightConstraint: NSLayoutConstraint?
	private var categories: [TrackerCategory] = [] {
		didSet { updateUI() }
	}
	
	weak var delegate: CategorySelectionDelegate?
	
	// MARK: - Init
	
	init(categories: [TrackerCategory], selectedCategory: TrackerCategory? = nil) {
		self.categories = categories
		self.selectedCategory = selectedCategory
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		screenTitle = "Категория"
		
		setupTableView()
		setupEmptyView()
		setupAddButton()
		updateUI()
	}
	
	// MARK: - Setup
	
	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = .ypCellBack
		tableView.layer.cornerRadius = Constants.cornerRadius
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.mediumPadding),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.commonPadding),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.commonPadding),
		])
		
		tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: Constants.tableViewCellHeight * CGFloat(categories.count))
		tableViewHeightConstraint?.isActive = true
	}
	
	private func setupEmptyView() {
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(emptyView)
		
		NSLayoutConstraint.activate([
			emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	private func setupAddButton() {
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
		view.addSubview(addButton)
		
		NSLayoutConstraint.activate([
			addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.mediumPadding),
			addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.mediumPadding),
			addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.commonPadding),
			addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
		])
	}
	
	// MARK: - Private Methods
	
	private func updateUI() {
		let isEmpty = categories.isEmpty
		tableView.isHidden = isEmpty
		emptyView.isHidden = !isEmpty
		
		let newHeight = CGFloat(categories.count) * Constants.tableViewCellHeight
		tableViewHeightConstraint?.constant = newHeight
		
		view.setNeedsLayout()
		view.layoutIfNeeded()
	}
	
	@objc private func addCategoryTapped() {
		let newCategoryVC = CategoryViewController(mode: .creation)
		newCategoryVC.delegate = self
		present(newCategoryVC, animated: true)
	}
	
	private func deleteCategory(at indexPath: IndexPath) {
		let categoryToDelete = categories[indexPath.row]
		categories.remove(at: indexPath.row)
		
		if categoryToDelete == selectedCategory {
			selectedCategory = nil
		}
		
		tableView.performBatchUpdates {
			tableView.deleteRows(at: [indexPath], with: .automatic)
		} completion: { [weak self] _ in
			guard let self else { return }
			self.updateUI()
			if !self.categories.isEmpty {
				let lastIndexPath = IndexPath(row: self.categories.count - 1, section: 0)
				self.tableView.reloadRows(at: [lastIndexPath], with: .none)
			}
		}
	}
	
	private func editCategory(at indexPath: IndexPath) {
		let oldCategory = categories[indexPath.row]
		let editCategoryVC = CategoryViewController(mode: .editing(initialText: oldCategory.title))
		editCategoryVC.delegate = self
		present(editCategoryVC, animated: true)
	}
}

// MARK: - CategoryViewControllerDelegate

extension CategorySelectionViewController: CategoryViewControllerDelegate {
	func categoryExists(with title: String) -> Bool {
		categories.contains { $0.title.caseInsensitiveCompare(title) == .orderedSame }
	}
	
	func didFinish(with title: String, mode: CategoryViewController.Mode) {
		switch mode {
			case .editing(let oldTitle):
				didEditCategory(with: oldTitle, newTitle: title)
			case .creation:
				didAddNewCategory(with: title)
		}
	}
	
	private func didAddNewCategory(with title: String) {
		let newCategory = TrackerCategory(title: title, trackers: [])
		categories.append(newCategory)
		
		let newIndexPath = IndexPath(row: categories.count - 1, section: 0)
		
		tableView.performBatchUpdates({
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		}, completion: { _ in
			self.updateUI()
			if self.categories.count > 1 {
				let previousIndexPath = IndexPath(row: self.categories.count - 2, section: 0)
				self.tableView.reloadRows(at: [previousIndexPath], with: .none)
			}
		})
	}
	
	private func didEditCategory(with oldTitle: String, newTitle: String) {
		guard let index = categories.firstIndex(where: { $0.title == oldTitle }) else { return }
		let oldCategory = categories[index]
		let updatedCategory = TrackerCategory(title: newTitle, trackers: oldCategory.trackers)
		categories[index] = updatedCategory
		
		if selectedCategory == oldCategory {
			selectedCategory = updatedCategory
		}
		
		let indexPath = IndexPath(row: index, section: 0)
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CategorySelectionViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.backgroundColor = .clear
		cell.textLabel?.text = categories[indexPath.row].title
		
		if categories[indexPath.row] == selectedCategory {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		if indexPath.row == categories.count - 1 {
			cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
		} else {
			cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.commonPadding, bottom: 0, right: Constants.commonPadding)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCategory = categories[indexPath.row]
		delegate?.didSelectCategory(selectedCategory, categories)
		dismiss(animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Constants.tableViewCellHeight
	}
	
	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
			guard let self else { return nil }
			
			let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
				self.deleteCategory(at: indexPath)
			}
			
			let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
				self.editCategory(at: indexPath)
			}
			
			return UIMenu(title: "", children: [editAction, deleteAction])
		}
	}
}
