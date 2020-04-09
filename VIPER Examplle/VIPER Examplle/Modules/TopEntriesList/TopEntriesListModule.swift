//
//  TopEntriesListModule.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

class TopEntriesListModule {
	func build() -> UIViewController {
		let router = TopEntriesListRouter()
		let interactor = TopEntriesListInteractor()
		let presenter = TopEntriesListPresenter(router: router, interactor: interactor)
		let viewController = TopEntriesListViewController(presenter: presenter)

		return viewController
	}
}