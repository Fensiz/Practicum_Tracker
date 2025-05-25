//
//  AppButton.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//

import UIKit

final class AppButton: UIButton {

	// MARK: - Nested Types

	enum AppButtonStyle {
		case filled(backgroundColor: UIColor = .ypBlack, textColor: UIColor = .ypWhite)
		case outlined(borderColor: UIColor = .ypRed, textColor: UIColor = .ypRed)
	}

	// MARK: - Private Properties

	private var style: AppButtonStyle?

	private var normalBackgroundColor: UIColor?
	private var normalTextColor: UIColor?

	private let disabledBackgroundColor: UIColor = .ypGray
	private let disabledTextColor: UIColor = .white

	// MARK: - Lifecycle

	override var isHighlighted: Bool {
		didSet {
			alpha = isHighlighted ? 0.6 : 1.0
		}
	}
	
	override var isEnabled: Bool {
		didSet { updateEnabledState() }
	}

	init(title: String, style: AppButtonStyle = .filled()) {
		super.init(frame: .zero)
		self.style = style
		configure(title: title, style: style)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configure(title: String, style: AppButtonStyle) {
		setTitle(title, for: .normal)
		titleLabel?.font = .ypMedium16
		layer.cornerRadius = Constants.cornerRadius
		translatesAutoresizingMaskIntoConstraints = false

		switch style {
			case .filled(let backgroundColor, let textColor):
				self.normalBackgroundColor = backgroundColor
				self.normalTextColor = textColor
				self.backgroundColor = backgroundColor
				setTitleColor(textColor, for: .normal)
				layer.borderWidth = 0

			case .outlined(let borderColor, let textColor):
				normalBackgroundColor = .clear
				normalTextColor = textColor
				backgroundColor = .clear
				setTitleColor(textColor, for: .normal)
				layer.borderColor = borderColor.cgColor
				layer.borderWidth = 1
		}
	}

	private func updateEnabledState() {
		backgroundColor = isEnabled ? normalBackgroundColor : disabledBackgroundColor
		setTitleColor(isEnabled ? normalTextColor : disabledTextColor, for: .normal)
	}
}
