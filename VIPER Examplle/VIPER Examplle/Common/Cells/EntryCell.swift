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
		fileprivate static let ThumbnailWidthMultiplier: CGFloat = 0.25
	}

	private let titleLabel = Label(font: Constants.TitleFont)
	private let dateLabel = Label(font: Constants.DateFont, alignment: .left)
	private let authorLabel = Label(font: Constants.AuthorFont, alignment: .right)
	private let commentsLabel = Label(font: Constants.CommentsFont, alignment: .left)
	private let readLabel = Label(font: Constants.ReadFont, alignment: .right)
	private let dismissButton = Button(title: Constants.DismissTitle)

	private let thumbnailImageView: ImageView = {
		let view = ImageView()
		view.isUserInteractionEnabled = true

		return view
	}()

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

		let statusStack = StackView(axis: .horizontal, spacing: Constants.Spacing)
		statusStack.setContentHuggingPriority(.defaultLow, for: .vertical)
		statusStack.addArrangedSubview(commentsLabel)
		statusStack.addArrangedSubview(readLabel)
		mainDataTextStack.addArrangedSubview(statusStack)

		mainDataStack.addArrangedSubview(mainDataTextStack)

		contentStack.addArrangedSubview(mainDataStack)

		contentStack.addArrangedSubview(dismissButton)

		NSLayoutConstraint.activate([
			thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.ThumbnailWidthMultiplier),
			thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
		])

		dismissButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
		thumbnailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
																	   action: #selector(thumbnailPressed)))
	}

	var model: EntryCellModel? {
		didSet {
			titleLabel.text = model?.title
			authorLabel.text = model?.author
			dateLabel.text = model?.date
			commentsLabel.text = model?.comments
			readLabel.text = model?.status

			guard let model = model else {
				thumbnailImageView.isHidden = false
				thumbnailImageView.image = nil
				return
			}

			if let thumbnail = model.thumbnail {
				thumbnailImageView.isHidden = false
				thumbnailImageView.load(fromURL: thumbnail)
			} else {
				thumbnailImageView.isHidden = true
				thumbnailImageView.image = nil
			}
		}
	}

	var dismissCell: ((EntryCell) -> Void)?
	@objc func dismissPressed() {
		dismissCell?(self)
	}

	var pressThumbnail: ((EntryCell) -> Void)?
	@objc func thumbnailPressed() {
		pressThumbnail?(self)
	}

	override func prepareForReuse() {
		model = nil
		dismissCell = nil
		pressThumbnail = nil
	}
}

struct EntryCellModel {
	let entry: RedditEntry

	var title: String {
		return entry.title
	}

	var author: String {
		return entry.author
	}

	var date: String {
		let secondsInterval = Date().timeIntervalSince1970 - entry.created
		let minutesInterval = secondsInterval / 60
		guard minutesInterval >= 1 else {
			return String(format: NSLocalizedString("%d seconds ago",comment: ""), Int(secondsInterval))
		}

		let hoursInterval = minutesInterval / 60
		guard hoursInterval >= 1 else {
			return String(format: NSLocalizedString("%d minutes ago", comment: ""), Int(minutesInterval))
		}

		return String(format: NSLocalizedString("%d hours ago", comment: ""), Int(hoursInterval))
	}

	var comments: String {
		return String(format: NSLocalizedString("%d comments", comment: ""), entry.comments)
	}

	var read: Bool = false
	var status: String {
		return read ? NSLocalizedString("Read", comment: "") : NSLocalizedString("Unread", comment: "")
	}

	var thumbnail: URL? {
		guard let urlString = entry.thumbnail else { return nil }
		return URL(string: urlString)
	}

	init(entry: RedditEntry) {
		self.entry = entry
	}
}
