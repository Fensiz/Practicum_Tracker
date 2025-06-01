//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 21.04.2025.
//

import UIKit

final class TrackerTypeSelectionViewController: BaseViewController {

	// MARK: - UI Elements

	private lazy var createHabitButton: UIButton = {
		let button = AppButton(title: "Habit")
		button.addAction(UIAction { [weak self] _ in
			self?.createHabit()
		}, for: .touchUpInside)
		return button
	}()

	private lazy var createNonRegularEventButton: UIButton = {
		let button = AppButton(title: "Irregular Event")
		button.addAction(UIAction { [weak self] _ in
			self?.createNonRegularEvent()
		}, for: .touchUpInside)
		return button
	}()

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [createHabitButton, createNonRegularEventButton])
		stack.spacing = Constants.commonPadding
		stack.axis = .vertical
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()

	// MARK: - Public Properties

	weak var delegate: TrackerTypeSelectionDelegate?

	// MARK: - Lifecycle

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		AnalyticsService.logEvent(.open, screen: .trackerTypeSelection)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(true)
		AnalyticsService.logEvent(.close, screen: .trackerTypeSelection)
	}

	// MARK: - Private Methods

	private func setupUI() {
		screenTitle = String(localized: "Create Tracker")
		view.backgroundColor = .ypWhite

		view.addSubview(stack)

		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.mediumPadding),
			stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.mediumPadding),
			createHabitButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
			createNonRegularEventButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
			stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}

	private func createHabit() {
		delegate?.didSelectTrackerType(.habit, vc: self)
	}

	private func createNonRegularEvent() {
		delegate?.didSelectTrackerType(.nonRegular, vc: self)
	}
}
