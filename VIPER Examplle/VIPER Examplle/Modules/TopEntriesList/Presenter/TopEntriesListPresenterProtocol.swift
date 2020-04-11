//
//  TopEntriesListPresenterProtocol.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

protocol TopEntriesListPresenterProtocol: class {
	var router: TopEntriesListRouterProtocol? { get set }
	var interactor: TopEntriesListInteractorProtocol? { get set }
	var view: TopEntriesListViewControllerProtocol? { get set }

	var state: TopEntriesListViewState { get }
	var headerButtonTitle: String? { get }

	func loadData()
	func entryButtonPressed(index: Int)
	func headerButtonPressed()
	func rowSelected(index: Int)
	func refreshData()

	func setError(message: String?)
	func loadEntries(entries: [EntryCellModel])
}

enum TopEntriesListViewState {
	case loading
	case error(message: String?)
	case entries(data: [EntryCellModel])
}
