//
//  TopEntriesRouter.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class TopEntriesListRouter: TopEntriesListRouterProtocol {
	weak var presenter: TopEntriesListPresenterProtocol?
	weak var view: UIViewController?

	let navigationController: UINavigationController

	func displayImage(entry: RedditEntry) {
		let entryImageViewController = EntryImageModule().build(entry: entry)
		navigationController.pushViewController(entryImageViewController, animated: true)
	}

	func setBaseView(viewController: UIViewController) {
		navigationController.viewControllers = [viewController]
	}

	init() {
		navigationController = UINavigationController()
		navigationController.restorationIdentifier = "Nav"
	}
}
