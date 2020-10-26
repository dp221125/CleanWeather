//
//  SceneDelegate.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		self.window = window
		
		self.window?.rootViewController = MainViewController()
		self.window?.makeKeyAndVisible()
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}

}

