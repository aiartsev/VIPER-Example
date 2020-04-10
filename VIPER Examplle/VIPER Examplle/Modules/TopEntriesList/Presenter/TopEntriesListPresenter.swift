//
//  TopEntriesListPresenter.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class TopEntriesListPresenter: TopEntriesListPresenterProtocol {

	private struct Constants {
		static let ErrorMessage = NSLocalizedString("An error has occurred.", comment: "")
	}

	var router: TopEntriesListRouterProtocol?
	var interactor: TopEntriesListInteractorProtocol?
	var state: TopEntriesListViewState = .loading
	weak var view: TopEntriesListViewControllerProtocol?

	init(router: TopEntriesListRouterProtocol, interactor: TopEntriesListInteractorProtocol) {
		self.router = router
		self.interactor = interactor

		router.presenter = self
		interactor.presenter = self
	}

	func setError(message: String? = nil) {
		state = .error(message: message ?? Constants.ErrorMessage)
		view?.reload()
	}

	func loadEntries(entries: [RedditEntry]) {
		state = .entries(data: entries)
		view?.reload()
	}

	func loadData() {
		state = .loading
		interactor?.getPosts()
	}
}
