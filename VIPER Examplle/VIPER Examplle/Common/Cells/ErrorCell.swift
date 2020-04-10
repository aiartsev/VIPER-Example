//
//  ErrorCell.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class ErrorCell: UITableViewCell {
	struct Constants {
		static let Identifier = "ErrorCell"
		fileprivate static let LabelInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
		fileprivate static let ErrorFont: UIFont = .systemFont(ofSize: 16.0)
	}

	private let errorLabel: UILabel = {
		let view = Label(font: Constants.ErrorFont, alignment: .center)
		view.numberOfLines = 0

		return view
	}()

	public var errorText: String? {
		didSet {
			errorLabel.text = errorText
		}
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		layout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func layout() {
		contentView.addSubview(errorLabel)

		NSLayoutConstraint.activate(contentView.constraintsAligning(subView: errorLabel,
														vertically: .fill(inset: Constants.LabelInsets),
														horizontally: .fill(inset: Constants.LabelInsets)))
	}
}
