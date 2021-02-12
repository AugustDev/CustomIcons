//
//  AppDelegate.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, WindowInjected {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window.makeKeyAndVisible()
        window.rootViewController = UINavigationController(rootViewController: ListController())
        window.tintColor = .darkGray
        return true
    }
}

