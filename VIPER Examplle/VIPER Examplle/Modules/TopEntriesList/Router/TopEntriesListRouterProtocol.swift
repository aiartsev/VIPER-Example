//
//  TopEntriesListRouterProtocol.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

protocol TopEntriesListRouterProtocol: class {
	var presenter: TopEntriesListPresenterProtocol? { get set }
	var navigationController: UINavigationController { get }

	func displayImage(entry: RedditEntry)
	func setBaseView(viewController: UIViewController)
}
