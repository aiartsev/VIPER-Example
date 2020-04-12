//
//  TopEntriesListInteractorProtocol.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

protocol TopEntriesListInteractorProtocol: class {
	var presenter: TopEntriesListPresenterProtocol? { get set }

	func getPosts(refresh: Bool)
}
