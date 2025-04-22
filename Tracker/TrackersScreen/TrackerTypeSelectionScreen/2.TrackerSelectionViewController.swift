//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 21.04.2025.
//

import UIKit

protocol TrackerTypeSelectionDelegate: AnyObject {
	func didSelectTrackerType(_ type: TrackerType, vc: UIViewController)
}

final class TrackerSelectionViewController: UIViewController {

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Создание трекера"
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.tintColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var createHabitButton: UIButton = {
		let button = UIButton()
		button.setTitle("Привычка", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
		button.backgroundColor = .black
		button.layer.cornerRadius = 16
		button.addAction(UIAction { [weak self] _ in self?.createHabit() }, for: .touchUpInside)
		return button
	}()

	private lazy var createNonRegularEventButton: UIButton = {
		let button = UIButton()
		button.setTitle("Нерегулярное событие", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
		button.backgroundColor = .black
		button.layer.cornerRadius = 16
		button.addAction(UIAction { [weak self] _ in self?.createNonRegularEvent() }, for: .touchUpInside)
		return button
	}()

	weak var delegate: TrackerTypeSelectionDelegate?

//	private var selectedTracker: Tracker?
//	private var selectedCategory: TrackerCategory?
//	private var categories: [TrackerCategory]?

	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white
		let stack = UIStackView(arrangedSubviews: [createHabitButton, createNonRegularEventButton])
		stack.spacing = 16
		stack.axis = .vertical
		stack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stack)
		view.addSubview(titleLabel)
		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			createHabitButton.heightAnchor.constraint(equalToConstant: 60),
			createNonRegularEventButton.heightAnchor.constraint(equalToConstant: 60),
			stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
		])
		title = "Создание трекера"
	}

	private func createHabit() {
		delegate?.didSelectTrackerType(.habit, vc: self)
	}

	private func createNonRegularEvent() {
		delegate?.didSelectTrackerType(.nonRegular, vc: self)
	}

//	private func presentNext() {
//		let formVC = CreationViewController(type: .habit)
//		present(formVC, animated: true)
//	}
}
