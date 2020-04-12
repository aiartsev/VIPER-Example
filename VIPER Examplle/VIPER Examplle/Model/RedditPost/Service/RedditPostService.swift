//
//  RedditPostService.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import Foundation

final class RedditPostService: RedditPostServiceProtocol {

	private struct Constants {
		static let GrantType = "https://oauth.reddit.com/grants/installed_client"
		static let UserName = "-DBHvhMD--SHKg:"
		static let Post = "POST"
		static let Get = "GET"
		static let ContentType = "Content-Type"
		static let URLEncoded = "application/x-www-form-urlencoded"
		static let Authorization = "Authorization"
		static let Host = "https://www.reddit.com/"
		static let AuthURI = "api/v1/access_token"
		static let TopPostsURL = "https://oauth.reddit.com/top/.json?t=all&limit=10"
	}

    let uuid: String
    var accessToken: AccessToken?

    init(deviceId: String) {
        self.uuid = deviceId
    }

	func authorize(completion: @escaping (Error?) -> Void) {
		let session = URLSession(configuration: .ephemeral)
		let url = URL(string: "\(Constants.Host)\(Constants.AuthURI)?grant_type=\(Constants.GrantType)&device_id=\(uuid)")!

        var request = URLRequest(url: url)
		request.httpMethod = Constants.Post

		let credentials = "Basic \(Data(Constants.UserName.utf8).base64EncodedString())"
		request.setValue(credentials, forHTTPHeaderField: Constants.Authorization)
		request.setValue(Constants.URLEncoded, forHTTPHeaderField: Constants.ContentType)

        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(error)
                return
            }

            do {
                let decoder = JSONDecoder()
                self.accessToken = try decoder.decode(AccessToken.self, from: data)
            } catch let error {
                completion(error)
                print(error.localizedDescription)
                return
            }

            print(self.accessToken ?? "ERROR")
            completion(error)
        })

        task.resume()
	}

	func getPosts(afterEntry: String?, completion: @escaping (TopListing?, Error?) -> Void) {
		guard let accessToken = accessToken, !accessToken.expired else {
			authorize() { [weak self] (error) in
				if let error = error {
					completion(nil, error)
					return
				}

				self?.getPosts(afterEntry: afterEntry, completion: completion)
			}

			return
		}

		let session = URLSession(configuration: .ephemeral)
		var urlString = Constants.TopPostsURL
		if let entryId = afterEntry {
			urlString = urlString.appending("&after=\(entryId)")
		}

		let url = URL(string: urlString)!

		var request = URLRequest(url: url)
		request.httpMethod = Constants.Get

		request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: Constants.Authorization)
		request.setValue(Constants.URLEncoded, forHTTPHeaderField: Constants.ContentType)

		let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?)  -> Void in
			guard let data = data else {
				completion(nil, error)
				return
			}

			do  {
				let decoder = JSONDecoder()
				let listingWrapper = try decoder.decode(ListingWrapper.self, from: data)
				completion(listingWrapper.data, error)
				return
			} catch let error {
				completion(nil, error)
				print(error.localizedDescription)
				return
			}
		})

		task.resume()
	}
}
