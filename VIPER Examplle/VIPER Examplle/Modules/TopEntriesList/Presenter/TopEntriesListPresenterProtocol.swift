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

	var cellData: [TopEntriesListCellType] { get }
	var headerButtonTitle: String? { get }

	func entryButtonPressed(index: Int)
	func entryThumbnailPressed(index: Int)
	func headerButtonPressed()
	func rowSelected(index: Int)
	func nextPage()
	func refresh()

	func setError(message: String?)
	func loadEntries(entries: [EntryCellModel])
}

enum TopEntriesListCellType {
	case loading
	case error(message: String?)
	case entry(data: EntryCellModel)

	var canBeDismissed: Bool {
		switch self {
		case .entry:
			return true
		default:
			return false
		}
	}
}
