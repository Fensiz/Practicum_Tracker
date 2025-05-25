//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 25.04.2025.
//

import UIKit

final class CategoryViewController: BaseViewController {
	
	// MARK: - Types
	
	enum Mode {
		case creation
		case editing(initialText: String)
	}
	
	// MARK: - Properties
	
	weak var delegate: CategoryViewControllerDelegate?
	private var mode: Mode
	
	// MARK: - UI Elements
	
	private lazy var textField: UITextField = {
		let tf = PaddedTextField(placeholder: "Введите название категории")
		tf.addAction(UIAction { [weak self] _ in self?.textFieldEditingChanged() }, for: .editingChanged)
		return tf
	}()
	
	private lazy var createButton: UIButton = {
		let title: String
		switch mode {
			case .creation:
				title = "Создать"
			case .editing:
				title = "Готово"
		}
		let button = AppButton(title: title)
		button.addAction(UIAction { [weak self] _ in self?.createButtonTapped() }, for: .touchUpInside)
		return button
	}()
	
	// MARK: - Init
	
	init(mode: Mode) {
		self.mode = mode
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
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
		textField.delegate = self
	}
	
	// MARK: - Actions
	
	private func createButtonTapped() {
		if let title = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
		   !title.isEmpty {
			delegate?.didFinish(with: title, mode: mode)
		}
		dismiss(animated: true)
	}
	
	// MARK: - Private
	
	private func textFieldEditingChanged() {
		let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		let isUnique = !(delegate?.categoryExists(with: trimmedText) ?? true)
		createButton.isEnabled = !trimmedText.isEmpty && isUnique
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
	
	private func setInitialText(_ text: String) {
		textField.text = text
		textFieldEditingChanged()
	}
}

// MARK: - TextField Delegate

extension CategoryViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
