//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//

import UIKit

class ScheduleCell: UITableViewCell {
	private let dayLabel = UILabel()
	private let toggle = UISwitch()
	var toggleAction: ((Bool) -> Void)?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with title: String, isOn: Bool) {
		dayLabel.text = title
		toggle.isOn = isOn
	}

	private func setup() {
		backgroundColor = .clear
		dayLabel.translatesAutoresizingMaskIntoConstraints = false
		toggle.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(dayLabel)
		contentView.addSubview(toggle)

		NSLayoutConstraint.activate([
			dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

			toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])

		toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
	}

	@objc private func toggleChanged() {
		toggleAction?(toggle.isOn)
	}
}
