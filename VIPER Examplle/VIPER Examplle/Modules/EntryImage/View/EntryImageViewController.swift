//
//  EntryImageViewController.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 12/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class EntryImageViewController: UIViewController, EntryImageViewProtocol {
	var presenter: EntryImagePresenterProtocol?

	private let imageView = ImageView()

	init(presenter: EntryImagePresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		presenter.view = self

		layout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		if let url = presenter?.imageURL {
			imageView.load(fromURL: url)
		}
	}

	override func encodeRestorableState(with coder: NSCoder) {
		presenter?.encodeState(coder: coder)
	}

	private func layout() {
		view.addSubview(imageView)
		NSLayoutConstraint.activate(view.constraintsAligning(subView: imageView,
															 vertically: .fill(inset: .zero),
															 horizontally: .fill(inset: .zero)))
	}
}
