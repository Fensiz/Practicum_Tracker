//
//  TrackerCreationTableViewCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 22.04.2025.
//

import UIKit

final class TrackerCreationTableViewCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		backgroundColor = .clear
	}
}
