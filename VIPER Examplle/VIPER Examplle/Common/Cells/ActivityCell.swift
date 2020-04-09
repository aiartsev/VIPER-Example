//
//  ActivityCell.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class ActivityCell: UITableViewCell {
	struct Constants {
		static let Identifier = "ActivityCell"
	}

	private let activityIndicator: UIActivityIndicatorView = ActivityView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		layout()

		activityIndicator.startAnimating()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func layout() {
		contentView.addSubview(activityIndicator)

		NSLayoutConstraint.activate(contentView.constraintsAligning(subView: activityIndicator,
														vertically: .center(offset: 0),
														horizontally: .center(offset: 0)))
	}
}
