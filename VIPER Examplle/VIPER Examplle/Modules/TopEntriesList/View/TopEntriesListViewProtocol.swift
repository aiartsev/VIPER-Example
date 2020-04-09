//
//  TopEntriesListViewProtocol.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

protocol TopEntriesListViewProtocol: class {
	var presenter: TopEntriesListPresenterProtocol? { get set }

	func dispaly(_ viewControllers: [UIViewController])
}
