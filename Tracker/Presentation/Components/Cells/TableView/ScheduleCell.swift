//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//

import UIKit

final class ScheduleCell: UITableViewCell {

	// MARK: - Public Properties

	var toggleAction: ((Bool) -> Void)?

	// MARK: - UI Elements

	private let dayLabel: UILabel = {
		let label = UILabel()
		label.font = .ypRegular17
		return label
	}()

	private let toggle: UISwitch = {
		let toggleSwitch = UISwitch()
		toggleSwitch.onTintColor = .ypBlue
		return toggleSwitch
	}()

	// MARK: - Initializers

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		setupActions()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	func configure(with title: String, isOn: Bool) {
		dayLabel.text = title
		toggle.isOn = isOn
	}

	// MARK: - Private Methods

	private func setupUI() {
		backgroundColor = .clear

		[dayLabel, toggle].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(view)
		}

		NSLayoutConstraint.activate([
			dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonPadding),
			dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

			toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonPadding),
			toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}

	private func setupActions() {
		toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
	}

	@objc
	private func toggleValueChanged() {
		toggleAction?(toggle.isOn)
	}
}


