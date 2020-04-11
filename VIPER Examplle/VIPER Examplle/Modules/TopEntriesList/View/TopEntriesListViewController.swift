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

	let tableView: UITableView = {
		let view = UITableView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsVerticalScrollIndicator = false
		view.separatorStyle = .none
		view.tableFooterView = UIView()

		return view
	}()

	init(presenter: TopEntriesListPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		presenter.view = self

		layout()
		bind()
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

	func reload(index: Int) {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
		}
	}

	private func layout() {
		view.addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	private func bind() {
		view.backgroundColor = .white

		tableView.delegate = self
		tableView.dataSource = self

		tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.Constants.Identifier)
		tableView.register(ErrorCell.self, forCellReuseIdentifier: ErrorCell.Constants.Identifier)
		tableView.register(EntryCell.self, forCellReuseIdentifier: EntryCell.Constants.Identifier)
	}
}

extension TopEntriesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let presenter = presenter else { return 0 }

		switch presenter.state {
		case .entries(let data):
			return data.count
		default:
			return 1
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let presenter = presenter else { return 0 }

		switch presenter.state {
		case .loading:
			return tableView.bounds.size.height
		default:
			return UITableView.automaticDimension
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
			entryCell.dismissCell = { [weak self] cell in
				guard let indexPath = tableView.indexPath(for: cell) else { return }
				self?.presenter?.dismissEntry(index: indexPath.row)
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .fade)
				tableView.endUpdates()
			}
			entryCell.model = model

		}

		return cell
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let state = presenter?.state, case .entries = state else { return UIView() }
		let dismissButton = Button(title: "Dismiss All")
		dismissButton.titleLabel?.textAlignment = .center

		dismissButton.addTarget(self, action: #selector(dismissAllPressed), for: .touchUpInside)
		let headerView = UIView()
		headerView.backgroundColor = .white
		headerView.addSubview(dismissButton)
		NSLayoutConstraint.activate(headerView.constraintsAligning(subView: dismissButton,
																   vertically: .fill(inset: .zero),
																   horizontally: .fill(inset: .zero)))

		return headerView
	}

	@objc private func dismissAllPressed() {
		presenter?.dismissAllEntries()
	}
}

extension TopEntriesListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		guard let state = presenter?.state, case .entries = state else { return nil }
		return indexPath
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.rowSelected(index: indexPath.row)
		tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
	}
}
