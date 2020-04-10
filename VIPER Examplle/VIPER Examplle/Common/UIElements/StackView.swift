//
//  StackView.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 10/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class StackView: UIStackView {
	init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		self.axis = axis
		self.spacing = spacing
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
