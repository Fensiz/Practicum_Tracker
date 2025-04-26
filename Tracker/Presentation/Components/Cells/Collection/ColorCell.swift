//
//  ColorCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
	static let reuseIdentifier = "ColorCell"

	private let colorView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 8
		view.clipsToBounds = true
		return view
	}()

	private let selectionBorderView: UIView = {
		let view = UIView()
		view.layer.borderWidth = 3
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.cornerRadius = 11
		view.backgroundColor = .clear
		view.isHidden = true // сначала скрыт
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = .clear
		contentView.addSubview(selectionBorderView)
		contentView.addSubview(colorView)

		NSLayoutConstraint.activate([
			selectionBorderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			selectionBorderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			selectionBorderView.widthAnchor.constraint(equalToConstant: 52),
			selectionBorderView.heightAnchor.constraint(equalToConstant: 52),

			colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			colorView.widthAnchor.constraint(equalToConstant: 40),
			colorView.heightAnchor.constraint(equalToConstant: 40)
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with color: UIColor, isSelected: Bool) {
		colorView.backgroundColor = color
		selectionBorderView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
		selectionBorderView.isHidden = !isSelected
	}
}
