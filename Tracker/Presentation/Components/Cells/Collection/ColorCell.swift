//
//  ColorCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {

	// MARK: - Reuse Identifier

	static let reuseIdentifier = "ColorCell"

	// MARK: - UI Elements

	private let colorView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.layer.cornerRadius = Constants.colorCellColorViewRadius
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let selectionBorderView: UIView = {
		let view = UIView()
		view.layer.borderWidth = Constants.colorCellOuterViewBorderWidth
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.cornerRadius = Constants.colorCellOuterViewRadius
		view.backgroundColor = .clear
		view.isHidden = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	// MARK: - Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	func configure(with color: UIColor, isSelected: Bool) {
		colorView.backgroundColor = color
		selectionBorderView.layer.borderColor = color.withAlphaComponent(Constants.colorCellSelectedOpacity).cgColor
		selectionBorderView.isHidden = !isSelected
	}

	// MARK: - Private Methods

	private func setupUI() {
		contentView.backgroundColor = .clear
		contentView.addSubview(selectionBorderView)
		contentView.addSubview(colorView)

		NSLayoutConstraint.activate([
			selectionBorderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			selectionBorderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			selectionBorderView.widthAnchor.constraint(equalToConstant: Constants.colorCellSize),
			selectionBorderView.heightAnchor.constraint(equalToConstant: Constants.colorCellSize),

			colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			colorView.widthAnchor.constraint(equalToConstant: Constants.colorCellColorSize),
			colorView.heightAnchor.constraint(equalToConstant: Constants.colorCellColorSize)
		])
	}
}
