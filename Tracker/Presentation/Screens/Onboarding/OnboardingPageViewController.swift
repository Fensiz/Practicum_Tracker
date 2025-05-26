//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.05.2025.
//


import UIKit

final class OnboardingPageViewController: UIViewController {
	private let imageName: String
	private let text: String

	private let imageView = UIImageView()
	private let label = UILabel()

	init(imageName: String, text: String) {
		self.imageName = imageName
		self.text = text
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
	}

	private func setupLayout() {
		imageView.image = UIImage(named: imageName)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imageView)

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])

		label.text = text
		label.font = .systemFont(ofSize: 32, weight: .bold)
		label.numberOfLines = 2
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)

		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 64),
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.commonPadding),
			label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.commonPadding),
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
