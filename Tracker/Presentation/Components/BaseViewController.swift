//
//  BaseViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//


import UIKit

class BaseViewController: UIViewController {

	var screenTitle: String? {
		didSet {
			guard let screenTitle else { return }
			titleLabel.text = String(localized: String.LocalizationValue(screenTitle))
		}
	}

	var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.tintColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		setupTitleLabel()
	}

	private func setupTitleLabel() {
		view.addSubview(titleLabel)

		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
}
