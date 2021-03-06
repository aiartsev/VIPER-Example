//
//  Label.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class Label: UILabel {
	init(font: UIFont, alignment: NSTextAlignment = .natural) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		self.font = font
		self.textAlignment = alignment
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
