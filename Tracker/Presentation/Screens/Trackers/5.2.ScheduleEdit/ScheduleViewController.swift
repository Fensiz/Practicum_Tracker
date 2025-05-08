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

	private let scrollView = UIScrollView()
	private let contentView = UIView()
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

		setupScrollView()
		setupTableView()
		setupDoneButton()
		layoutUI()
	}

	private func setupScrollView() {
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		contentView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.allowsSelection = false
		tableView.register(ScheduleCell.self, forCellReuseIdentifier: "cell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.isScrollEnabled = false
		tableView.backgroundColor = .ypCellBack
		tableView.layer.cornerRadius = Constants.cornerRadius
		tableView.clipsToBounds = true
		contentView.addSubview(tableView)
	}

	private func setupDoneButton() {
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		doneButton.addAction(UIAction { [weak self] _ in
			guard let self else { return }
			self.delegate?.didSelectDays(selectedDays)
			self.dismiss(animated: true)
		}, for: .touchUpInside)
		view.addSubview(doneButton)
	}

	private func layoutUI() {
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
			tableView.heightAnchor.constraint(equalToConstant: Constants.tableViewCellHeight * 7),

			doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
			doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
			doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			doneButton.heightAnchor.constraint(equalToConstant: 60),
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
