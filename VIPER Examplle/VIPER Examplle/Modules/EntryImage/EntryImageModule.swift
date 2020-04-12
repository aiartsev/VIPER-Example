//
//  EntryImageModule.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 12/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class EntryImageModule {
	func build(entry: RedditEntry) -> UIViewController {
		let router = EntryImageRouter()
		let interactor = EntryImageInteractor(entry: entry)
		let presenter = EntryImagePresenter(router: router, interactor: interactor)
		let viewController = EntryImageViewController(presenter: presenter)

		return viewController
	}
}
