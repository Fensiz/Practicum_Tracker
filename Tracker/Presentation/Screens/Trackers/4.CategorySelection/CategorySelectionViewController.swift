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
	private let scrollView = UIScrollView()
	private let contentView = UIView()

	private let presenter: CategorySelectionPresenterProtocol
	private var tableViewHeightConstraint: NSLayoutConstraint?

	// MARK: - Init

	init(presenter: CategorySelectionPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		screenTitle = "Категория"

		setupUI()
		presenter.viewDidLoad()
		firstUpdateUI()
		tableView.reloadData()
	}

	// MARK: - Setup

	private func setupUI() {
		[scrollView, contentView, tableView, emptyView, addButton].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
		}

		addButton.addAction(UIAction { [weak self] _ in self?.addCategoryTapped() }, for: .touchUpInside)

		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = .ypCellBack
		tableView.layer.cornerRadius = Constants.cornerRadius
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

		view.addSubview(emptyView)
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubview(tableView)
		contentView.addSubview(addButton)

		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

			tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

			addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
			addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
			addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			addButton.heightAnchor.constraint(equalToConstant: 60),
		])
		tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: Constants.tableViewCellHeight * CGFloat(presenter.numberOfCategories))
		tableViewHeightConstraint?.isActive = true
	}

	// MARK: - Private Methods

	private func firstUpdateUI() {
		let isEmpty = presenter.numberOfCategories == 0
		tableView.isHidden = isEmpty
		emptyView.isHidden = !isEmpty

		let newHeight = CGFloat(presenter.numberOfCategories) * Constants.tableViewCellHeight
		tableViewHeightConstraint?.constant = newHeight
	}

	private func updateUI() {
		firstUpdateUI()

		view.setNeedsLayout()
		view.layoutIfNeeded()
	}

	private func addCategoryTapped() {
		let newCategoryVC = CategoryViewController(mode: .creation)
		newCategoryVC.delegate = self
		present(newCategoryVC, animated: true)
	}

	private func deleteCategory(at indexPath: IndexPath) {
		presenter.deleteCategory(at: indexPath.row)
	}

	private func editCategory(at indexPath: IndexPath) {
		let oldCategory = presenter.category(at: indexPath.row)
		let editCategoryVC = CategoryViewController(mode: .editing(initialText: oldCategory.title))
		editCategoryVC.delegate = self
		present(editCategoryVC, animated: true)
	}
}

// MARK: - View Protocol

extension CategorySelectionViewController: CategorySelectionViewProtocol {
	func updateCategories(_ categories: [TrackerCategory]) {
		tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
		updateUI()
	}

	func showError(_ message: String) {
		let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
		present(alert, animated: true)
	}

	func performBatchUpdate(insert: [Int], delete: [Int], reload: [Int]) {
		let insertIndexPaths = insert.map { IndexPath(row: $0, section: 0) }
		let deleteIndexPaths = delete.map { IndexPath(row: $0, section: 0) }
		let reloadIndexPaths = reload.map { IndexPath(row: $0, section: 0) }

		tableView.performBatchUpdates({
			tableView.insertRows(at: insertIndexPaths, with: .automatic)
			tableView.deleteRows(at: deleteIndexPaths, with: .automatic)
			tableView.reloadRows(at: reloadIndexPaths, with: .none)
		})

		updateUI()
	}

	func dismissView() {
		dismiss(animated: true)
	}
}

// MARK: - CategoryViewControllerDelegate

extension CategorySelectionViewController: CategoryViewControllerDelegate {
	func categoryExists(with title: String) -> Bool {
		return presenter.categoryExists(with: title)
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
		presenter.addCategory(title: title)
	}

	private func didEditCategory(with oldTitle: String, newTitle: String) {
		presenter.editCategory(oldTitle: oldTitle, newTitle: newTitle)
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CategorySelectionViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.numberOfCategories
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.backgroundColor = .ypCellBack
		let category = presenter.category(at: indexPath.row)
		cell.textLabel?.text = category.title

		if category == presenter.selectedCategory {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}

		if indexPath.row == presenter.numberOfCategories - 1 {
			cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
		} else {
			cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.commonPadding, bottom: 0, right: Constants.commonPadding)
		}

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.didSelectCategory(at: indexPath.row)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Constants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
			guard let self else { return nil }

			let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
				self?.deleteCategory(at: indexPath)
			}

			let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
				self?.editCategory(at: indexPath)
			}

			return UIMenu(title: "", children: [editAction, deleteAction])
		}
	}
}
