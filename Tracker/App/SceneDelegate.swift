//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: windowScene)
		let pageController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
		pageController.switchAction = { [weak self] in
			guard let self, let window = self.window else { return }

			let newRootVC = TabBarController()
			guard let snapshot = window.snapshotView(afterScreenUpdates: true) else { return }
			newRootVC.view.addSubview(snapshot)

			window.rootViewController = newRootVC

			UIView.animate(withDuration: 0.4, animations: {
				snapshot.alpha = 0
			}, completion: { _ in
				snapshot.removeFromSuperview()
			})

			DefaultsService.isFirstLaunch = false
		}
		window?.rootViewController = DefaultsService.isFirstLaunch ? pageController : TabBarController()
		window?.makeKeyAndVisible()
	}
}
