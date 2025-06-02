//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

import UIKit

class StatisticViewController: UIViewController {
	private let viewModel: StatisticViewModel
	private let emptyView = TrackersEmptyView(text: "There is nothing to analyze yet", emoji: "😢")
	private lazy var tableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.register(StatisticCell.self, forCellReuseIdentifier: StatisticCell.reuseIdentifier)
		return tableView
	}()

	init(viewModel: StatisticViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		title = String(localized: "Statistics")
		navigationController?.navigationBar.prefersLargeTitles = true

		[emptyView, tableView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}

		NSLayoutConstraint.activate([
			emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		emptyView.isHidden = viewModel.containTrackers()
		tableView.isHidden = !emptyView.isHidden
		if !tableView.isHidden {
			tableView.reloadData()
		}
	}
}

extension StatisticViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.statistics.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.reuseIdentifier, for: indexPath) as? StatisticCell ?? StatisticCell()
		let stat = viewModel.statistics[indexPath.row]
		cell.configure(title: stat.name, count: stat.value())
		return cell
	}
}
