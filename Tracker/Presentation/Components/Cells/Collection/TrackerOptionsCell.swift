//
//  TrackerOptionsCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit

final class TrackerOptionsCell: UICollectionViewCell {
	static let reuseIdentifier = "TrackerOptionsCell"

	private var tableView: UITableView?

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with tableView: UITableView) {
		// Убираем предыдущие сабвью (если переиспользуется ячейка)
		contentView.subviews.forEach { $0.removeFromSuperview() }

		self.tableView = tableView
		tableView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonPadding),
			tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonPadding),
			tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
}
