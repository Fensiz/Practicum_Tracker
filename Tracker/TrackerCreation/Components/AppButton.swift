//
//  AppButton.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//

import UIKit

enum AppButtonStyle {
	case filled(backgroundColor: UIColor = .black, textColor: UIColor = .white)
	case outlined(borderColor: UIColor = .ypRed, textColor: UIColor = .ypRed)
}

final class AppButton: UIButton {

	private var style: AppButtonStyle?

	// Цвета по состояниям
	private var normalBackgroundColor: UIColor?
	private var normalTextColor: UIColor?

	private var disabledBackgroundColor: UIColor = .systemGray5
	private var disabledTextColor: UIColor = .systemGray

	override var isHighlighted: Bool {
		didSet {
			alpha = isHighlighted ? 0.6 : 1.0
		}
	}

	override var isEnabled: Bool {
		didSet {
			updateEnabledState()
		}
	}

	init(title: String, style: AppButtonStyle = .filled()) {
		super.init(frame: .zero)
		self.style = style
		configure(title: title, style: style)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure(title: String, style: AppButtonStyle) {
		setTitle(title, for: .normal)
		titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
		layer.cornerRadius = 16
		translatesAutoresizingMaskIntoConstraints = false

		switch style {
		case .filled(let backgroundColor, let textColor):
			self.normalBackgroundColor = backgroundColor
			self.normalTextColor = textColor
			self.backgroundColor = backgroundColor
			setTitleColor(textColor, for: .normal)
			layer.borderWidth = 0

		case .outlined(let borderColor, let textColor):
			self.normalBackgroundColor = .clear
			self.normalTextColor = textColor
			backgroundColor = .clear
			setTitleColor(textColor, for: .normal)
			layer.borderColor = borderColor.cgColor
			layer.borderWidth = 1
		}
	}

	private func updateEnabledState() {
		if isEnabled {
			backgroundColor = normalBackgroundColor
			setTitleColor(normalTextColor, for: .normal)
		} else {
			backgroundColor = disabledBackgroundColor
			setTitleColor(disabledTextColor, for: .normal)
		}
	}
}
