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

	func loadEntries(entries: [EntryCellModel]) {
		state = .entries(data: entries)
		view?.reload()
	}

	func loadData() {
		state = .loading
		interactor?.getPosts()
	}

	func dismissEntry(index: Int) {
		guard case .entries(var data) = state, index < data.count, index >= 0 else { return }

		data.remove(at: index)
		state = .entries(data: data)
//		view?.reload()
	}

	func dismissAllEntries() {
		guard case .entries = state else { return }
		// TODO: There's an interesting error that happens when there is no values for the UITableView.
		//	Adding an empty state cell would fix that error.
		state = .entries(data: [])
		view?.reload()
	}

	func rowSelected(index: Int) {
		guard case .entries(var data) = state else { return }
		var entry = data[index]
		entry.read = true
		data[index] = entry
		state = .entries(data: data)
		view?.reload(index: index)
	}
}
