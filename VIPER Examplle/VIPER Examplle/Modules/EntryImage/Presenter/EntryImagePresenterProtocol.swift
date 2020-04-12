//
//  EntryImagePresenterProtocol.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 12/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

protocol EntryImagePresenterProtocol: class {
	var router: EntryImageRouterProtocol? { get set }
	var interactor: EntryImageInteractorProtocol? { get set }
	var view: EntryImageViewProtocol? { get set }

	var imageURL: URL? { get }

	func encodeState(coder: NSCoder)
}
