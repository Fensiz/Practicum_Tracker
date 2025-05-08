//
//  TextFieldCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit

final class TextFieldCell: UICollectionViewCell {

	// MARK: - Reuse Identifier

	static let reuseIdentifier = "TextFieldCell"

	// MARK: - UI Elements

	private let warningLabel: UILabel = {
		let label = UILabel()
		label.textColor = .ypRed
		label.font = .ypRegular17
		label.isHidden = true
		label.text = "Ограничение 38 символов"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Public Methods

	func configure(with textField: UITextField) {
		contentView.subviews.forEach { $0.removeFromSuperview() }

		textField.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(textField)
		contentView.addSubview(warningLabel)

		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: contentView.topAnchor),
			textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonPadding),
			textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonPadding),
			textField.heightAnchor.constraint(equalToConstant: Constants.commonHeight),

			warningLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
			warningLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.smallPadding),
			warningLabel.heightAnchor.constraint(equalToConstant: Constants.textFieldCellWarningLabelHeight)
		])
	}

	func updateWarningLabel(isHidden: Bool) {
		warningLabel.isHidden = isHidden
	}
}
