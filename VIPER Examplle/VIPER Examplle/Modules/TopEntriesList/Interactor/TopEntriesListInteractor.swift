//
//  TopEntriesListInteractor.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

final class TopEntriesListInteractor: TopEntriesListInteractorProtocol {
	weak var presenter: TopEntriesListPresenterProtocol?

	let service: RedditPostService

	init(service: RedditPostService) {
		self.service = service
	}

	func getPosts() {
		service.getPosts(afterEntry: nil) { [weak self] listing, error in
			guard error == nil, let listing = listing else {
				self?.presenter?.setError(message: nil)
				return
			}

			self?.presenter?.loadEntries(entries: listing.entries.map { $0.data })
		}
	}
}
