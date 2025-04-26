//
//  CategorySelectionViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
	func didSelectCategory(_ category: TrackerCategory, _ categories: [TrackerCategory])
}

final class CategorySelectionViewController: BaseViewController {

	private let tableView = UITableView()
	private let emptyView = TrackersEmptyView(text: "Привычки и события можно объединить по смыслу")
	private let addButton = AppButton(title: "Добавить категорию")

	var categories: [TrackerCategory] = [] {
		didSet {
			updateUI()
		}
	}
	var selectedCategory: TrackerCategory?

	private var tableViewHeightConstraint: NSLayoutConstraint?

	weak var delegate: CategorySelectionDelegate?

	init(categories: [TrackerCategory], selectedCategory: TrackerCategory? = nil) {
		self.categories = categories
		self.selectedCategory = selectedCategory
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		screenTitle = "Категория"

		setupTableView()
		setupEmptyView()
		setupAddButton()
		updateUI()
	}

	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = .ypCellBack
		tableView.layer.cornerRadius = 16
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		view.addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
		addButton.addAction(UIAction { [weak self] _ in self?.addCategoryTapped() }, for: .touchUpInside)
		view.addSubview(addButton)

		NSLayoutConstraint.activate([
			addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			addButton.heightAnchor.constraint(equalToConstant: 60)
		])
	}

	private func updateUI() {
		let isEmpty = categories.isEmpty
		tableView.isHidden = isEmpty
		emptyView.isHidden = !isEmpty

		let newHeight = CGFloat(categories.count) * Constants.tableViewCellHeight
		tableViewHeightConstraint?.constant = newHeight
		view.setNeedsLayout()
		view.layoutIfNeeded()
	}

	private func addCategoryTapped() {
		let newCategoryVC = NewCategoryViewController()
		newCategoryVC.onCategoryCreated = { [weak self] categoryName in
			guard let self else { return }
			self.categories.append(TrackerCategory(title: categoryName, trackers: []))
			self.tableView.reloadData()
			print(self.categories)
		}
		present(newCategoryVC, animated: true)
	}
}

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
			cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
}
