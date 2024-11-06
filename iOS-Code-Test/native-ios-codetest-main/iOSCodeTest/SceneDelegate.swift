//
// Copyright © 2022 ASOS. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		// Create new window in scene and programatically set the root VC
		guard let windowScene = (scene as? UIWindowScene) else {
			return
		}
		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = UINavigationController(rootViewController: HomeViewController())
		self.window = window
		window.makeKeyAndVisible()
	}
}
