//
//  TabBarController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//


import UIKit

final class TabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		let appearance = UITabBarAppearance()
		appearance.configureWithDefaultBackground()
		appearance.backgroundColor = .white
		tabBar.standardAppearance = appearance
		tabBar.scrollEdgeAppearance = appearance // без этой строки в iOS 15 не отображается разделитель

		let presenter = TrackersPresenter()
		let trackersViewController = UINavigationController(
			rootViewController: TrackersViewController(presenter: presenter)
		)

		trackersViewController.tabBarItem = UITabBarItem(
			title: "Трекеры",
			image: UIImage(systemName: "record.circle.fill"),
			selectedImage: nil
		)

		let statisticViewController = StatiscticViewController()

		statisticViewController.tabBarItem = UITabBarItem(
			title: "Статистика",
			image: UIImage(systemName: "hare.fill"),
			selectedImage: nil
		)

		self.viewControllers = [trackersViewController, statisticViewController]
	}
}
