//
//  AppDelegate.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var restored = false

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		if restored { return true }
		setupMainWindow()

		return true
	}

	func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
		return true
	}

	func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
		setupMainWindow()
		restored = true
		return true
	}

	func setupMainWindow() {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = TopEntriesListModule().build()
		window?.makeKeyAndVisible()
	}

}

