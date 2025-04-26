//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//


import UIKit

final class NewCategoryViewController: BaseViewController {

	var onCategoryCreated: ((String) -> Void)?

	private lazy var textField: UITextField = {
		let tf = PaddedTextField(placeholder: "Введите название категории")
		tf.addAction(UIAction { [weak self] _ in self?.textFieldEditingChanged() }, for: .editingChanged)
		return tf
	}()

	private lazy var createButton: UIButton = {
		let button = AppButton(title: "Создать")
		button.addAction(UIAction { [weak self] _ in self?.createButtonTapped() }, for: .touchUpInside)
		return button
	}()

	private func textFieldEditingChanged() {
		let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		createButton.isEnabled = !trimmedText.isEmpty
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		screenTitle = "Новая категория"
		view.backgroundColor = .systemBackground
		setupLayout()
		textFieldEditingChanged()
	}

	private func setupLayout() {
		view.addSubview(textField)
		view.addSubview(createButton)

		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
			textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			textField.heightAnchor.constraint(equalToConstant: 75),

			createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			createButton.heightAnchor.constraint(equalToConstant: 60)
		])
	}

	private func createButtonTapped() {
		guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
		onCategoryCreated?(text)
		dismiss(animated: true)
	}
}
