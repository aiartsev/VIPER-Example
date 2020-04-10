//
//  Button.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 10/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class Button: UIButton {
	init(title: String) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		setTitle(title, for: .normal)
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
