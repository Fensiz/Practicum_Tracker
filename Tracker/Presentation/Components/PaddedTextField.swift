//
//  PaddedTextField.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//

import UIKit

final class PaddedTextField: UITextField {

	private var textPadding: UIEdgeInsets

	init(
		textPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 48),
		placeholder: String? = nil
	) {
		self.textPadding = textPadding
		super.init(frame: .zero)

		if let placeholder = placeholder {
			self.attributedPlaceholder = NSAttributedString(
				string: String(localized: String.LocalizationValue(placeholder)),
				attributes: [
					.foregroundColor: UIColor.ypGray
				]
			)
		}
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .ypCellBack
		layer.cornerRadius = 16
		layer.masksToBounds = true
		font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular)
		textColor = .label
		clearButtonMode = .whileEditing
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		bounds.inset(by: textPadding)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		bounds.inset(by: textPadding)
	}

	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		bounds.inset(by: textPadding)
	}

	override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
		let original = super.clearButtonRect(forBounds: bounds)
		return original.offsetBy(dx: -16, dy: 0)
	}
}
