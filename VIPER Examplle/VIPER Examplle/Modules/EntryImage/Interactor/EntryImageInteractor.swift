//
//  EntryImageInteractor.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 12/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

final class EntryImageInteractor: EntryImageInteractorProtocol {
	var presenter: EntryImagePresenterProtocol?

	private let entry: RedditEntry
	var imageURL: URL? {
		return entry.url
	}

	init(entry: RedditEntry) {
		self.entry = entry
	}
}
