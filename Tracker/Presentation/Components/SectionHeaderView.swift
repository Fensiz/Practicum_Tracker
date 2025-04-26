//
//  SectionHeaderView.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//


import UIKit

final class SectionHeaderView: UICollectionReusableView {

	static let identifier = "SectionHeaderView"

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .ypBold19
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(titleLabel)

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with title: String) {
		titleLabel.text = title
	}
}
