//
//  EntryImageInteractorProtocol.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 12/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

protocol EntryImageInteractorProtocol: class {
	var presenter: EntryImagePresenterProtocol? { get set }

	var imageURL: URL? { get }
}
