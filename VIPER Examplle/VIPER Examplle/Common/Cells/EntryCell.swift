//
//  EntryCell.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 10/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class EntryCell: UITableViewCell {
	struct Constants {
		static let Identifier = "EntryCell"
		fileprivate static let ContentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
		fileprivate static let TitleFont: UIFont = .boldSystemFont(ofSize: 16.0)
		fileprivate static let DateFont: UIFont = .italicSystemFont(ofSize: 12.0)
		fileprivate static let AuthorFont: UIFont = .systemFont(ofSize: 12.0)
		fileprivate static let CommentsFont: UIFont = .systemFont(ofSize: 12.0)
		fileprivate static let ReadFont: UIFont = .systemFont(ofSize: 12.0)
		fileprivate static let Spacing: CGFloat = 10
		fileprivate static let DismissTitle = NSLocalizedString("Dismiss", comment: "")
	}

	private let titleLabel = Label(font: Constants.TitleFont)
	private let dateLabel = Label(font: Constants.DateFont, alignment: .left)
	private let authorLabel = Label(font: Constants.AuthorFont, alignment: .right)
	private let thumbnailImageView = ImageView()
	private let commentsLabel = Label(font: Constants.CommentsFont, alignment: .left)
	private let readLabel = Label(font: Constants.ReadFont, alignment: .right)
	private let dismissButton = Button(title: Constants.DismissTitle)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		layout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func layout() {
		let contentStack = StackView(axis: .vertical, spacing: Constants.Spacing)

		contentView.addSubview(contentStack)
		NSLayoutConstraint.activate(contentView.constraintsAligning(subView: contentStack,
																	vertically: .fill(inset: Constants.ContentInsets),
																	horizontally: .fill(inset: Constants.ContentInsets)))

		let mainDataStack = StackView(axis: .horizontal, spacing: Constants.Spacing)
		mainDataStack.addArrangedSubview(thumbnailImageView)

		let mainDataTextStack = StackView(axis: .vertical, spacing: Constants.Spacing)
		mainDataTextStack.addArrangedSubview(titleLabel)

		let subtitleStack = StackView(axis: .horizontal, spacing: Constants.Spacing)
		subtitleStack.addArrangedSubview(dateLabel)
		subtitleStack.addArrangedSubview(authorLabel)

		mainDataTextStack.addArrangedSubview(subtitleStack)
		mainDataStack.addArrangedSubview(mainDataTextStack)

		contentStack.addArrangedSubview(mainDataStack)

		let statusStack = StackView(axis: .horizontal, spacing: Constants.Spacing)
		statusStack.addArrangedSubview(commentsLabel)
		statusStack.addArrangedSubview(readLabel)

		contentStack.addArrangedSubview(statusStack)
		contentStack.addArrangedSubview(dismissButton)

		dismissButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
	}

	var model: EntryCellModel? {
		didSet {
			titleLabel.text = model?.title
			authorLabel.text = model?.author
			dateLabel.text = model?.date
			commentsLabel.text = model?.comments
			readLabel.text = model?.status

			if let thumbnail = model?.thumbnail {
				thumbnailImageView.isHidden = false
				// TODO: configure thumbnail
			} else {
				thumbnailImageView.isHidden = true
			}
		}
	}

	@objc func dismissPressed() {
		model?.dismissCell?()
	}

	override func prepareForReuse() {
		model = nil
	}
}

struct EntryCellModel {
	private let entry: RedditEntry

	var title: String {
		return entry.title
	}

	var author: String {
		return entry.author
	}

	var date: String {
		return "some date"
	}

	var comments: String {
		return String(format: NSLocalizedString("%d comments", comment: ""), entry.comments)
	}

	var status: String {
		return entry.read ? NSLocalizedString("Read", comment: "") : NSLocalizedString("Unread", comment: "")
	}

	var thumbnail: String? {
		return entry.thumbnail
	}

	init(entry: RedditEntry) {
		self.entry = entry
	}

	var dismissCell: (() -> Void)?
}