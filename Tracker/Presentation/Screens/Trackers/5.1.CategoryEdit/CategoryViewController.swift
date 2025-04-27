//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//

import UIKit

final class CategoryViewController: BaseViewController {

	enum Mode {
		case creation
		case editing(initText: String)
	}

	init(mode: Mode) {
		self.mode = mode
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var mode: Mode
	weak var delegate: CategoryViewControllerDelegate?

	private lazy var textField: UITextField = {
		let tf = PaddedTextField(placeholder: "Введите название категории")
		tf.addAction(UIAction { [weak self] _ in self?.textFieldEditingChanged() }, for: .editingChanged)
		return tf
	}()

	private lazy var createButton: UIButton = {
		let name: String
		switch mode {
			case .creation:
				name = "Создать"
			case .editing:
				name = "Готово"
		}
		let button = AppButton(title: name)
		button.addAction(UIAction { [weak self] _ in self?.createButtonTapped() }, for: .touchUpInside)
		return button
	}()

	private func textFieldEditingChanged() {
		let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		let isUnique = !(delegate?.categoryExists(with: trimmedText) ?? false)
		createButton.isEnabled = !trimmedText.isEmpty && isUnique
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		switch mode {
			case .creation:
				screenTitle = "Новая категория"
			case .editing(let text):
				screenTitle = "Редактирование категории"
				setInitialText(text)
		}
		view.backgroundColor = .systemBackground
		setupLayout()
		textFieldEditingChanged()
	}

	private func setupLayout() {
		view.addSubview(textField)
		view.addSubview(createButton)

		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.mediumPadding),
			textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.commonPadding),
			textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.commonPadding),
			textField.heightAnchor.constraint(equalToConstant: Constants.commonHeight),

			createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.commonPadding),
			createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.mediumPadding),
			createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.mediumPadding),
			createButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
		])
	}

	private func createButtonTapped() {
		guard let newTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !newTitle.isEmpty else { return }
		switch mode {
			case .creation:
				delegate?.didAddNewCategory(with: newTitle)
			case .editing(let title):
				delegate?.didEditCategory(with: title, newTitle: newTitle)
		}
		dismiss(animated: true)
	}

	func setInitialText(_ text: String) {
		textField.text = text
		textFieldEditingChanged()
	}
}
