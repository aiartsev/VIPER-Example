//
//  TopEntriesListInteractor.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

final class TopEntriesListInteractor: TopEntriesListInteractorProtocol {
	weak var presenter: TopEntriesListPresenterProtocol?

	let service: RedditPostServiceProtocol
	var afterEntry: String?

	init(service: RedditPostServiceProtocol) {
		self.service = service
	}

	func getPosts(refresh: Bool) {
		if refresh {
			afterEntry = nil
		}
		
		service.getPosts(afterEntry: afterEntry) { [weak self] listing, error in
			guard error == nil, let listing = listing else {
				self?.presenter?.setError(message: nil)
				return
			}

			self?.afterEntry = listing.after
			self?.presenter?.loadEntries(entries: listing.entries.map { EntryCellModel(entry: $0.data) })
		}
	}
}
