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
		static let DismissAllTitle = NSLocalizedString("Dismiss All", comment: "")
	}

	var router: TopEntriesListRouterProtocol?
	var interactor: TopEntriesListInteractorProtocol?
	private(set) var cellData: [TopEntriesListCellType] = [.loading]
	weak var view: TopEntriesListViewControllerProtocol?

	private var pageNumber = 0

	var headerButtonTitle: String? {
		return Constants.DismissAllTitle
	}

	init(router: TopEntriesListRouterProtocol, interactor: TopEntriesListInteractorProtocol) {
		self.router = router
		self.interactor = interactor

		router.presenter = self
		interactor.presenter = self
	}

	func setError(message: String? = nil) {
		cellData = [.error(message: message ?? Constants.ErrorMessage)]
		view?.reload()
	}

	func loadEntries(entries: [EntryCellModel]) {
		pageNumber += 1
		let newCellData = entries.map { TopEntriesListCellType.entry(data: $0) }
		if let lastCell = cellData.last, case .loading = lastCell {
			cellData.removeLast()
		}
		cellData.append(contentsOf: newCellData)
		cellData.append(.loading)
		view?.reload()
	}

	func entryButtonPressed(index: Int) {
		if cellData[index].canBeDismissed {
			cellData.remove(at: index)
			view?.delete(index: index)
		}
	}

	func headerButtonPressed() {
		cellData = cellData.filter { !$0.canBeDismissed }
		view?.reload()
	}

	func rowSelected(index: Int) {
		guard case .entry(var data) = cellData[index] else { return }
		data.read = true
		cellData[index] = .entry(data: data)
	}

	func refresh() {
		pageNumber = 0
		interactor?.getPosts(refresh: true)
	}

	func nextPage() {
		if pageNumber < 5 {
			interactor?.getPosts(refresh: false)
		} else {
			if let lastCell = cellData.last, case .loading = lastCell {
				cellData.removeLast()
				view?.delete(index: cellData.count)
			}
		}
	}
}
