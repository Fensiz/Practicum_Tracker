//
//  StatisticCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 01.06.2025.
//

import UIKit

final class StatisticCell: UITableViewCell {
	static let reuseIdentifier = "StatisticCell"

	private let titleLabel = UILabel()
	private let countLabel = UILabel()
	private let gradientLayer = CAGradientLayer()
	private let shapeLayer = CAShapeLayer()
	private lazy var stack = UIStackView(arrangedSubviews: [countLabel, titleLabel])

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		updateGradientBorder()
	}

	private func setupUI() {
		selectionStyle = .none
		backgroundColor = .clear

		contentView.backgroundColor = .white
		contentView.layer.cornerRadius = 12
		contentView.layer.masksToBounds = true

		titleLabel.font = .ypMedium12
		titleLabel.textColor = .label

		countLabel.font = .ypBold34
		countLabel.textColor = .label

		stack.axis = .vertical
		stack.alignment = .leading
		stack.distribution = .fill
		stack.spacing = 8
		stack.translatesAutoresizingMaskIntoConstraints = false

		contentView.addSubview(stack)

		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
			stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
			stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
			stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
			contentView.heightAnchor.constraint(equalToConstant: 102),
		])

		// Setup gradient
		gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		gradientLayer.colors = [
			UIColor.grRed.cgColor,
			UIColor.grGreen.cgColor,
			UIColor.grBlue.cgColor
		]
		contentView.layer.addSublayer(gradientLayer)

		// Setup shape mask
		shapeLayer.lineWidth = 1
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.strokeColor = UIColor.black.cgColor
		gradientLayer.mask = shapeLayer
	}

	private func updateGradientBorder() {
		gradientLayer.frame = contentView.bounds
		let path = UIBezierPath(
			roundedRect: contentView.bounds.insetBy(dx: 16, dy: 6),
			cornerRadius: contentView.layer.cornerRadius
		)
		shapeLayer.path = path.cgPath
	}

	func configure(title: String, count: Int) {
		titleLabel.text = title
		countLabel.text = "\(count)"
	}
}
