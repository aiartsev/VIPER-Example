//
//  TopEntriesListView.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class TopEntriesListViewController: UIViewController, TopEntriesListViewControllerProtocol {
	var presenter: TopEntriesListPresenterProtocol?

	init(presenter: TopEntriesListPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		presenter.view = self
		view.backgroundColor = .white

		layout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension TopEntriesListViewController {
	private func layout() {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Hello World!"

		view.addSubview(label)
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
