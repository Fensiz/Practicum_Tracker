//
//  TrackerCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 21.04.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {

	static let reuseIdentifier = "TrackerCell"

	private let topContainerView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.layer.masksToBounds = true
		return view
	}()

	private let emojiBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .white.withAlphaComponent(0.3)
		view.layer.cornerRadius = 12
		view.layer.masksToBounds = true
		return view
	}()

	private let emojiLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16)
		label.textAlignment = .center
		return label
	}()

	private let countLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17)
		label.textColor = .label
		return label
	}()

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .medium)
		label.textColor = .white
		label.numberOfLines = 2
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var addButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 24)
		button.tintColor = .white
		button.backgroundColor = .black
		button.layer.cornerRadius = 17
		button.layer.masksToBounds = true
		return button
	}()

	private let bottomStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 8
		stack.alignment = .center
		return stack
	}()

	private var isCompleted = false
	private var trackerColor: UIColor = .black

	override func prepareForReuse() {
		super.prepareForReuse()
		addButton.removeTarget(nil, action: nil, for: .allEvents)
		addButton.setTitle(nil, for: .normal)
		addButton.setImage(nil, for: .normal)
		isCompleted = false
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with tracker: Tracker, count: Int, action: @escaping () -> Void, isCompleted: Bool) {
		self.isCompleted = isCompleted
		self.trackerColor = tracker.color

		nameLabel.text = tracker.name
		emojiLabel.text = tracker.emoji
		topContainerView.backgroundColor = tracker.color
		addButton.backgroundColor = tracker.color

		let daysText: String
		switch count {
			case 1: daysText = "день"
			case 2...4: daysText = "дня"
			default: daysText = "дней"
		}
		countLabel.text = "\(count) \(daysText)"

		addButton.addAction(UIAction { [weak self] _ in
			guard let self = self else { return }
			self.isCompleted.toggle()
			action()
			self.updateUI()
		}, for: .touchUpInside)

		updateUI()
	}

	private func updateUI() {
		if isCompleted {
			addButton.setImage(UIImage(named: "done"), for: .normal)
			addButton.backgroundColor = trackerColor.withAlphaComponent(0.3)
			addButton.tintColor = trackerColor
		} else {
			addButton.setImage(UIImage(systemName: "plus"), for: .normal)
			addButton.backgroundColor = trackerColor
			addButton.tintColor = .white
		}
	}

	private func setupUI() {
		contentView.addSubview(topContainerView)
		contentView.addSubview(bottomStack)

		topContainerView.addSubview(emojiBackgroundView)
		topContainerView.addSubview(nameLabel)
		emojiBackgroundView.addSubview(emojiLabel)

		bottomStack.addArrangedSubview(countLabel)
		bottomStack.addArrangedSubview(addButton)

		[topContainerView, bottomStack, emojiBackgroundView, emojiLabel, addButton].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate([
			topContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			topContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			topContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			topContainerView.heightAnchor.constraint(equalToConstant: 90),

			emojiBackgroundView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 12),
			emojiBackgroundView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 12),
			emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
			emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),

			emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
			emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),

			bottomStack.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 8),
			bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
			bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
			bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

			addButton.widthAnchor.constraint(equalToConstant: 34),
			addButton.heightAnchor.constraint(equalToConstant: 34),

			nameLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -12),
			nameLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 12),
			nameLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -12),
			nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: topContainerView.bottomAnchor, constant: -12)
		])
	}
}
