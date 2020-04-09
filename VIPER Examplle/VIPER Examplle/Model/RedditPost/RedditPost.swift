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
    let thumbnail: String
    let image: String?
    let comments: Int

    enum CodingKeys: String, CodingKey {
        case author
        case thumbnail
        case created
        case title
        case image = "url"
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
