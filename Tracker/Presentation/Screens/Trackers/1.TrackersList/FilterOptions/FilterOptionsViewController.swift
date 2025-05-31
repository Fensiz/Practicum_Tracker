//
//  FilterOptionsViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 31.05.2025.
//

import UIKit

final class FilterOptionsViewController: BaseViewController {
	private let viewModel: FilterOptionsViewModel
	private lazy var tableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = .ypCellBack
		tableView.layer.cornerRadius = Constants.cornerRadius
		tableView.separatorColor = .ypGray
		tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	init(viewModel: FilterOptionsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		screenTitle = "Filters"

		view.addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			tableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.options.count) * Constants.tableViewCellHeight),
		])
	}
}


extension FilterOptionsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.options.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
			assertionFailure("Ячейка не найдена")
			return UITableViewCell()
		}
		let filter = viewModel.options[indexPath.row]
		let isLast = indexPath.row == viewModel.options.count - 1
		let isSelected = filter == viewModel.selectedOption
		cell.configure(
			with: String(localized: String.LocalizationValue(viewModel.options[indexPath.row].rawValue)),
			isSelected: isSelected,
			isLast: isLast
		)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didSelectOption(at: indexPath.row)
		dismiss(animated: true)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Constants.tableViewCellHeight
	}
}
