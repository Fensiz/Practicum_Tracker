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

		view.backgroundColor = .ypWhite

		let appearance = UITabBarAppearance()
		appearance.configureWithDefaultBackground()
		appearance.backgroundColor = .ypWhite
		appearance.shadowColor = .ypSepar
		tabBar.standardAppearance = appearance
		if #available(iOS 15.0, *) {
			tabBar.scrollEdgeAppearance = appearance // без этой строки в iOS 15 не отображается разделитель
		}

		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let repository = TrackerRepository(context: context)
		let presenter = TrackersPresenter(repository: repository)
		repository.delegate = presenter
		let trackersViewController = UINavigationController(
			rootViewController: TrackersViewController(presenter: presenter)
		)

		trackersViewController.tabBarItem = UITabBarItem(
			title: String(localized: "Trackers"),
			image: UIImage(systemName: "record.circle.fill"),
			selectedImage: nil
		)

		let statisticViewController = StatisticViewController()

		statisticViewController.tabBarItem = UITabBarItem(
			title: String(localized: "Statistics"),
			image: UIImage(systemName: "hare.fill"),
			selectedImage: nil
		)

		self.viewControllers = [trackersViewController, statisticViewController]
	}
}
