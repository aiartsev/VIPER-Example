//
//  EntryImageInteractor.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 12/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

final class EntryImageInteractor: EntryImageInteractorProtocol {
	private struct Constants {
		static let ImageURLKey = "ImageURL"
	}

	var presenter: EntryImagePresenterProtocol?

	private let entry: RedditEntry
	var imageURL: URL? {
		return entry.url
	}

	init(entry: RedditEntry) {
		self.entry = entry
	}

	init?(coder: NSCoder) {
		//TODO: A proper way would be to encode the whole RedditEntry object, but here it would mean a
		// conversion to a NSCoding compliant class.
		guard let urlString = coder.decodeObject(forKey: Constants.ImageURLKey) as? String else { return nil }
		entry = RedditEntry(title: "", author: "", created: 0, thumbnail: urlString, comments: 0, imageAddress: urlString)
	}

	func encodeState(coder: NSCoder) {
		guard let url = entry.url?.absoluteString else { return }
		coder.encode(url, forKey: Constants.ImageURLKey)
	}
}
