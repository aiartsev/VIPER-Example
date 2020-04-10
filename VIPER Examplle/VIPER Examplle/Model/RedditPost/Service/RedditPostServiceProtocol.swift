//
//  RedditPostServiceProtocol.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 10/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

protocol RedditPostService: class {
	func authorize(completion: @escaping (Error?) -> Void)
	func getPosts(afterEntry: String?, completion: @escaping (TopListing?, Error?) -> Void)
}
