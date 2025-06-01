//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

import UIKit

class StatisticViewController: UIViewController {
	let emptyView = TrackersEmptyView(text: "There is nothing to analyze yet", emoji: "😢")

	override func viewDidLoad() {
		super.viewDidLoad()

		title = String(localized: "Statistics")
		navigationController?.navigationBar.prefersLargeTitles = true
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(emptyView)

		NSLayoutConstraint.activate([
			emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
}
