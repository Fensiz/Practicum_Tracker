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
		window?.rootViewController = TabBarController()
		window?.makeKeyAndVisible()
	}
}
