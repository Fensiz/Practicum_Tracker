//
//  TrackerCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 21.04.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {

	// MARK: - Reuse Identifier

	static let reuseIdentifier = "TrackerCell"

	// MARK: - UI Elements

	private let topContainerView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.layer.masksToBounds = true
		return view
	}()

	private let emojiBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .white.withAlphaComponent(Constants.colorCellEmojiBackOpacity)
		view.layer.cornerRadius = Constants.trackerCellEmojiSize / 2
		view.layer.masksToBounds = true
		return view
	}()

	private let emojiLabel: UILabel = {
		let label = UILabel()
		label.font = .ypMedium16
		label.textAlignment = .center
		return label
	}()

	private let countLabel: UILabel = {
		let label = UILabel()
		label.font = .ypMedium12
		label.textColor = .ypBlack
		return label
	}()

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = .ypMedium12
		label.textColor = .white
		label.numberOfLines = Constants.trackerCellLineLimit
		label.textAlignment = .left
		return label
	}()

	private let addButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .ypRegular17
		button.tintColor = .ypWhite
		button.backgroundColor = .ypBlack
		button.layer.cornerRadius = Constants.trackerCellAddButtonSize / 2
		button.layer.masksToBounds = true
		return button
	}()

	private let bottomStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = Constants.trackerCellSmallPadding
		stack.alignment = .center
		return stack
	}()

	// MARK: - Private Properties

	private var isCompleted = false
	private var trackerColor: UIColor = .black

	// MARK: - Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		addButton.removeTarget(nil, action: nil, for: .allEvents)
		addButton.setTitle(nil, for: .normal)
		addButton.setImage(nil, for: .normal)
		isCompleted = false
	}

	func contextPreviewView() -> UIView {
		return topContainerView
	}

	func contextPreviewViewSnapshot() -> UIView {
		let snapshot = topContainerView.snapshotView(afterScreenUpdates: false) ?? topContainerView
		snapshot.layer.cornerRadius = 5
		snapshot.layer.masksToBounds = true
		return snapshot
	}

	// MARK: - Public Methods

	func configure(with tracker: Tracker, count: Int, action: @escaping () -> Void, isCompleted: Bool, isActive: Bool) {
		self.isCompleted = isCompleted
		self.trackerColor = tracker.color

		nameLabel.text = tracker.name
		emojiLabel.text = tracker.emoji
		topContainerView.backgroundColor = tracker.color
		addButton.backgroundColor = tracker.color
		countLabel.text = daysText(count)
		addButton.isEnabled = isActive

		addButton.addAction(UIAction { [weak self] _ in
			action()
			self?.updateUI()
		}, for: .touchUpInside)

		updateUI()
	}

	// MARK: - Private Methods

	private func daysText(_ count: Int) -> String {
		let daysText: String
		switch count {
			case 1: daysText = "день"
			case 2...4: daysText = "дня"
			default: daysText = "дней"
		}
		return "\(count) \(daysText)"
	}

	private func updateUI() {
		if isCompleted {
			addButton.setTitle("", for: .normal)
			addButton.setImage(UIImage(named: "done"), for: .normal)
			addButton.backgroundColor = trackerColor.withAlphaComponent(Constants.trackerCellAddButtonOpacity)
		} else {
			addButton.setImage(nil, for: .normal)
			addButton.setTitle("＋", for: .normal)
			addButton.backgroundColor = trackerColor
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

		[topContainerView, bottomStack, emojiBackgroundView, emojiLabel, addButton, nameLabel].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate([
			topContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			topContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			topContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			topContainerView.heightAnchor.constraint(equalToConstant: Constants.trackerCellTopContainerHeight),

			emojiBackgroundView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: Constants.trackerCellPadding),
			emojiBackgroundView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: Constants.trackerCellPadding),
			emojiBackgroundView.widthAnchor.constraint(equalToConstant: Constants.trackerCellEmojiSize),
			emojiBackgroundView.heightAnchor.constraint(equalToConstant: Constants.trackerCellEmojiSize),

			emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
			emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),

			nameLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: Constants.trackerCellPadding),
			nameLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -Constants.trackerCellPadding),
			nameLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -Constants.trackerCellPadding),

			bottomStack.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: Constants.trackerCellSmallPadding),
			bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.trackerCellPadding),
			bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.trackerCellPadding),
			bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.trackerCellSmallPadding),

			addButton.widthAnchor.constraint(equalToConstant: Constants.trackerCellAddButtonSize),
			addButton.heightAnchor.constraint(equalToConstant: Constants.trackerCellAddButtonSize)
		])
	}
}
