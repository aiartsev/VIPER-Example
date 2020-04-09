//
//  TopEntriesListPresenter.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

final class TopEntriesListPresenter: TopEntriesListPresenterProtocol {
	var router: TopEntriesListRouterProtocol?
	var interactor: TopEntriesListInteractorProtocol?
	var state: TopEntriesListViewState
	weak var view: TopEntriesListViewControllerProtocol?

	init(router: TopEntriesListRouterProtocol, interactor: TopEntriesListInteractorProtocol) {
		self.router = router
		self.interactor = interactor
		state = .loading

		router.presenter = self
		interactor.presenter = self
	}
}
