//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

import UIKit

class StatisticViewController: UIViewController {
	private let statistics: [(String, Int)] = [("Лучший период", 6)]
	private let emptyView = TrackersEmptyView(text: "There is nothing to analyze yet", emoji: "😢")
	private lazy var tableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.register(StatisticCell.self, forCellReuseIdentifier: StatisticCell.reuseIdentifier)
		return tableView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = String(localized: "Statistics")
		navigationController?.navigationBar.prefersLargeTitles = true


		if statistics.isEmpty {
			emptyView.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(emptyView)
			NSLayoutConstraint.activate([
				emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			])
		} else {
			view.addSubview(tableView)
			tableView.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			])
		}
	}
}

extension StatisticViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		statistics.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.reuseIdentifier, for: indexPath) as? StatisticCell ?? StatisticCell()
		let stat = statistics[indexPath.row]
		cell.configure(title: stat.0, count: stat.1)
		return cell
	}
}
