//
//  TopEntriesListView.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class TopEntriesListViewController: UITableViewController, TopEntriesListViewControllerProtocol {
	var presenter: TopEntriesListPresenterProtocol?

	init(presenter: TopEntriesListPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		presenter.view = self

		configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter?.loadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		reload()
	}

	func reload() {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
		}
	}

	private func configure() {
		view.backgroundColor = .white

		tableView.showsVerticalScrollIndicator = false
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView()

		tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.Constants.Identifier)
		tableView.register(ErrorCell.self, forCellReuseIdentifier: ErrorCell.Constants.Identifier)
		tableView.register(EntryCell.self, forCellReuseIdentifier: EntryCell.Constants.Identifier)
	}
}

extension TopEntriesListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let presenter = presenter else { return 0 }

		switch presenter.state {
		case .entries(let data):
			return data.count
		default:
			return 1
		}
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let presenter = presenter else { return 0 }

		switch presenter.state {
		case .loading:
			return tableView.bounds.size.height
		default:
			return UITableView.automaticDimension
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let state = presenter?.state ?? .loading

		switch state {
		case .loading:
			return configureLoadingCell(tableView: tableView, indexPath: indexPath)
		case .error(let message):
			return configureErrorCel(tableView: tableView, indexPath: indexPath, message: message)
		case .entries(let data):
			return configureEntryCel(tableView: tableView, indexPath: indexPath, model: data[indexPath.row])
		}
	}

	private func configureLoadingCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: ActivityCell.Constants.Identifier, for: indexPath)
	}

	private func configureErrorCel(tableView: UITableView, indexPath: IndexPath, message: String?) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ErrorCell.Constants.Identifier, for: indexPath)

		if let errorCell = cell as? ErrorCell {
			errorCell.errorText = message
		}

		return cell
	}

	private func configureEntryCel(tableView: UITableView, indexPath: IndexPath, model: EntryCellModel) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.Constants.Identifier, for: indexPath)

		if let entryCell = cell as? EntryCell {
			var cellModel = model
			cellModel.dismissCell = { [weak self] in
				self?.presenter?.dismissEntry(index: indexPath.row)
			}
			entryCell.model = cellModel

		}

		return cell
	}

	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let state = presenter?.state, case .entries = state else { return UIView() }
		let dismissButton = Button(title: "Dismiss All")

		dismissButton.addTarget(self, action: #selector(dismissAllPressed), for: .touchUpInside)

		return dismissButton
	}

	@objc private func dismissAllPressed() {
		presenter?.dismissAllEntries()
	}
}
