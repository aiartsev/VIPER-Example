//
//  ImageView.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 10/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class ImageView: UIImageView {
	let activityView = ActivityView()

	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		contentMode = .scaleAspectFill
		clipsToBounds = true

		addSubview(activityView)
		NSLayoutConstraint.activate(constraintsAligning(subView: activityView,
														vertically: .center(offset: 0),
														horizontally: .center(offset: 0)))
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func load(fromURL url: URL) {
        self.image = nil
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url, completionHandler: {[weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
			self?.activityView.stopAnimating()
            guard let data = data, let image = UIImage(data: data) else {
				self?.isHidden = true
                return
            }

			self?.isHidden = false
            self?.image = image
        })

		activityView.startAnimating()
        task.resume()
    }
}
