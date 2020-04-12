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

	func reload() {
		DispatchQueue.main.async { [weak self] in
			if let data = self?.presenter?.cellData, data.contains(where: { $0.canBeDismissed }) {
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

	func delete(index: Int) {
		tableView.beginUpdates()
		tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
		tableView.endUpdates()
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
		presenter?.nextPage()
	}
}

extension TopEntriesListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.cellData.count ?? 0
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let presenter = presenter else { return 0 }

		guard presenter.cellData.count == 1, let firstCell = presenter.cellData.first, case .loading = firstCell else {
			return UITableView.automaticDimension
		}

		return tableView.bounds.size.height
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cellType = presenter?.cellData[indexPath.row], case .loading = cellType {
			presenter?.nextPage()
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellData = presenter?.cellData[indexPath.row] ?? .loading

		switch cellData {
		case .loading:
			return configureLoadingCell(tableView: tableView, indexPath: indexPath)
		case .error(let message):
			return configureErrorCel(tableView: tableView, indexPath: indexPath, message: message)
		case .entry(let data):
			return configureEntryCel(tableView: tableView, indexPath: indexPath, model: data)
		}
	}

	private func configureLoadingCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.Constants.Identifier, for: indexPath)

		if let activityCell = cell as? ActivityCell {
			activityCell.startAnimating()
		}

		return cell
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
		guard let cellData = presenter?.cellData[indexPath.row], case .entry = cellData else { return nil }
		return indexPath
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.beginUpdates()
		presenter?.rowSelected(index: indexPath.row)
		tableView.reloadRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()
		tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
	}
}
