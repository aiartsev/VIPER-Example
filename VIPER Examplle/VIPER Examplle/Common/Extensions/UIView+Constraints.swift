//
//  UIView+Constraints.swift
//  VIPER Examplle
//
//  Created by Alexandre Iartsev on 09/04/2020.
//  Copyright © 2020 Alex Iartsev. All rights reserved.
//

import UIKit

extension UIView {
	func constraintsAligning(subView: UIView, vertically: Alignment, horizontally: Alignment) -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()

		switch vertically {
		case .fill(let inset):
			constraints.append(contentsOf: [
				subView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
				subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom)
			])
		case .center(let offset):
			constraints.append(subView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset))
		default:
			break
		}

		switch horizontally {
		case .fill(let inset):
			constraints.append(contentsOf: [
				subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
				subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right)
			])
		case .center(let offset):
			constraints.append(subView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset))
		default:
			break
		}

		return constraints
	}
}

enum Alignment {
	case none
	case fill(inset: UIEdgeInsets)
	case center(offset: CGFloat)
}
