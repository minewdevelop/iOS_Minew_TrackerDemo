//
//  AppDelegate.swift
//  TrackerKitDemo
//
//  Created by Minewtech on 2020/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.backgroundColor = UIColor.lightGray
        window?.rootViewController = UINavigationController(rootViewController:ViewController())
        window?.makeKeyAndVisible()
        return true
    }
}

