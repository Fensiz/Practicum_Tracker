//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//

import UIKit

final class ScheduleViewController: BaseViewController {
	weak var delegate: ScheduleViewControllerDelegate?

	private var selectedDays: Set<WeekDay>

	private let tableView = UITableView()
	private let doneButton = AppButton(title: "Готово")

	init(days: Set<WeekDay>?) {
		selectedDays = days ?? Set<WeekDay>()
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		screenTitle = "Расписание"

		setupTableView()
		setupDoneButton()
		layoutUI()
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.allowsSelection = false
		tableView.register(ScheduleCell.self, forCellReuseIdentifier: "cell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.isScrollEnabled = false
		tableView.backgroundColor = .ypCellBack
		tableView.layer.cornerRadius = 16
		tableView.clipsToBounds = true
		view.addSubview(tableView)
	}

	@objc private func doneButtonTapped() {
		delegate?.didSelectDays(selectedDays)
		dismiss(animated: true)
	}

	private func setupDoneButton() {
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
		view.addSubview(doneButton)
	}

	private func layoutUI() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			tableView.heightAnchor.constraint(equalToConstant: Constants.tableViewCellHeight * 7),

			doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			doneButton.heightAnchor.constraint(equalToConstant: 60)
		])
	}
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		WeekDay.allCases.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScheduleCell else {
			return UITableViewCell()
		}
		let day = WeekDay.allCases[indexPath.row]
		cell.configure(with: day.title, isOn: selectedDays.contains(day))
		cell.toggleAction = { [weak self] isOn in
			guard let self = self else { return }
			if isOn {
				self.selectedDays.insert(day)
			} else {
				self.selectedDays.remove(day)
			}
		}
		if indexPath.row == WeekDay.allCases.count - 1 {
			cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
		} else {
			cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Constants.tableViewCellHeight
	}
}
