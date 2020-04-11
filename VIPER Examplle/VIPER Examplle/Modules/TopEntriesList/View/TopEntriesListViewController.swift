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

	let headerButton: UIButton = {
		let view = Button()
		view.titleLabel?.textAlignment = .center

		return view
	}()

	let tableView: UITableView = {
		let view = UITableView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsVerticalScrollIndicator = false
		view.separatorStyle = .none
		view.tableFooterView = UIView()

		return view
	}()

	let refreshControl: UIRefreshControl = {
		let view = UIRefreshControl()
		view.backgroundColor = .white

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
			if let state = self?.presenter?.state, case .entries = state {
				self?.headerButton.isHidden = false
			} else {
				self?.headerButton.isHidden = true
			}

			self?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
			self?.refreshControl.endRefreshing()
		}
	}

	func reload(index: Int) {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
		}
	}

	private func layout() {
		let contentStack = StackView(axis: .vertical)

		view.addSubview(contentStack)

		NSLayoutConstraint.activate([
			contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])

		contentStack.addArrangedSubview(headerButton)
		contentStack.addArrangedSubview(tableView)

		tableView.addSubview(refreshControl)
	}

	private func bind() {
		view.backgroundColor = .white

		headerButton.setTitle(presenter?.headerButtonTitle, for: .normal)
		headerButton.addTarget(self, action: #selector(headerButtonPressed), for: .touchUpInside)

		tableView.delegate = self
		tableView.dataSource = self

		tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.Constants.Identifier)
		tableView.register(ErrorCell.self, forCellReuseIdentifier: ErrorCell.Constants.Identifier)
		tableView.register(EntryCell.self, forCellReuseIdentifier: EntryCell.Constants.Identifier)

		refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
	}

	@objc private func refreshPulled() {
		presenter?.refreshData()
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
				self?.presenter?.entryButtonPressed(index: indexPath.row)
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .fade)
				tableView.endUpdates()
			}
			entryCell.model = model

		}

		return cell
	}

	@objc private func headerButtonPressed() {
		presenter?.headerButtonPressed()
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
