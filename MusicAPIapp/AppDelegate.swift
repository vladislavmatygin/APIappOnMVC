//
//  AppDelegate.swift
//  MusicAPIapp
//
//  Created by Владислав Матыгин on 05.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.overrideUserInterfaceStyle = .light
        
        let searchVC = SearchViewController()
        let nav = UINavigationController()
        nav.viewControllers = [searchVC]
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
}

