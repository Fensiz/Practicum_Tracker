//
//  TrackerOptionsCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.04.2025.
//

import UIKit

final class TrackerOptionsCell: UICollectionViewCell {

	// MARK: - Reuse Identifier

	static let reuseIdentifier = "TrackerOptionsCell"

	// MARK: - Private Properties

	private var tableView: UITableView?

	// MARK: - Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	func configure(with tableView: UITableView) {
		clearContent()
		self.tableView = tableView

		tableView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonPadding),
			tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonPadding),
			tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}

	// MARK: - Private Methods

	private func clearContent() {
		contentView.subviews.forEach { $0.removeFromSuperview() }
	}
}
