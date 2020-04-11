//
//  RedditPost.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

struct RedditEntry: Codable {
    let title: String
    let author: String
    let created: Double
    let thumbnail: String?
    let comments: Int

	var url: URL? {
		guard let urlString = imageAddress else { return nil }
		return URL(string: urlString)
	}

	private let imageAddress: String?

	init(title: String, author: String, created: Double, thumbnail: String?, comments: Int, imageAddress: String?) {
		self.title = title
		self.author = author
		self.created = created
		self.thumbnail = thumbnail
		self.comments = comments
		self.imageAddress = imageAddress
	}

    enum CodingKeys: String, CodingKey {
        case author
        case thumbnail
        case created
        case title
        case imageAddress = "url"
        case comments = "num_comments"
    }
}

struct EntryWrapper: Codable {
    let data: RedditEntry
}

struct TopListing: Codable {
    let modHash: String
    let entries: [EntryWrapper]
    let after: String?
    let before: String?

    enum CodingKeys: String, CodingKey {
        case modHash = "modhash"
        case entries = "children"
        case after
        case before
    }
}

struct ListingWrapper: Codable {
    let data: TopListing
}
