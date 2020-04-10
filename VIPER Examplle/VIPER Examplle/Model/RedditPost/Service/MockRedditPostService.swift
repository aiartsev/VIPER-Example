//
//  MockRedditPostService.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 10/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

class MockRedditPostService: RedditPostService {

	private let authorizationDelay: Double
	private let postsDelay: Double

	init(authorizationDelay: Double, postsDelay: Double) {
		self.authorizationDelay = authorizationDelay
		self.postsDelay = postsDelay
	}

	func authorize(completion: @escaping (Error?) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + authorizationDelay) {
			completion(nil)
		}
	}

	func getPosts(afterEntry: String?, completion: @escaping (TopListing?, Error?) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + postsDelay) {
			let entries = [
				EntryWrapper(data: RedditEntry(title: "Title 1", author: "Author 1", created: 0, thumbnail: "", comments: 5, imageAddress: nil)),
				EntryWrapper(data: RedditEntry(title: "Title 2", author: "Author 2", created: 0, thumbnail: "", comments: 5, imageAddress: nil)),
				EntryWrapper(data: RedditEntry(title: "Title 3", author: "Author 3", created: 0, thumbnail: "", comments: 5, imageAddress: nil)),
				EntryWrapper(data: RedditEntry(title: "Title 4", author: "Author 4", created: 0, thumbnail: "", comments: 5, imageAddress: nil))
			]
			let listing = TopListing(modHash: "", entries: entries, after: nil, before: nil)

			completion(listing, nil)
		}
	}
}
