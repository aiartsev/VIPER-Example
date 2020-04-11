//
//  ActivityView.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

final class ActivityView: UIActivityIndicatorView {
	init() {
		super.init(style: .medium)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
