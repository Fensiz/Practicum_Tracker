//
//  TextFieldCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit

final class TextFieldCell: UICollectionViewCell {
	static let reuseIdentifier = "TextFieldCell"

	private let warningLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red
		label.font = Constants.ypRegular17
		label.isHidden = true
		label.text = "Ограничение 38 символов"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

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
			warningLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
			warningLabel.heightAnchor.constraint(equalToConstant: 22)
		])
	}

	func updateWarningLabel(isHidden: Bool) {
		warningLabel.isHidden = isHidden
	}
}
