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
	var view: TopEntriesListViewProtocol? { get set }

	func setupViewControllers()
}
