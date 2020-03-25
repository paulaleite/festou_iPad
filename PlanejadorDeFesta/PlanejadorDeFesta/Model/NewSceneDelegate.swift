//
//  NewSceneDelegate.swift
//  PlanejadorDeFesta
//
//  Created by Paula Leite on 25/03/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
// Declare conformance to UIWindowSceneDelegate, allowing you to respond to window scene events.
class CreateDelegate: UIResponder, UIWindowSceneDelegate {
  // Create a variable to hold a UIWindow. You populate this when you create your scene.
  var window: UIWindow?

  // Implement scene(_:willConnectTo:options:), which allows you to define the startup environment and views.
  func scene(_ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      // Create a new window using the UIWindowScene passed to you by UIKit.
      let window = UIWindow(windowScene: windowScene)
      // Instantiate a new instance of the GuestsTableViewController.
        window.rootViewController = GuestsTableViewController()
      // Set the window property to the new window.
      self.window = window
      // Make the new window visible.
      window.makeKeyAndVisible()
    }
  }
}
