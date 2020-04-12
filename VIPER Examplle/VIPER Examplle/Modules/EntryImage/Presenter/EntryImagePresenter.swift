//
//  EntryImagePresenter.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 12/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

final class EntryImagePresenter: EntryImagePresenterProtocol {
	var router: EntryImageRouterProtocol?
	var interactor: EntryImageInteractorProtocol?
	weak var view: EntryImageViewProtocol?

	var imageURL: URL? {
		return interactor?.imageURL
	}

	init(router: EntryImageRouterProtocol, interactor: EntryImageInteractorProtocol) {
		self.router = router
		self.interactor = interactor

		router.presenter = self
		interactor.presenter = self
	}

	func encodeState(coder: NSCoder) {
		interactor?.encodeState(coder: coder)
	}
}
