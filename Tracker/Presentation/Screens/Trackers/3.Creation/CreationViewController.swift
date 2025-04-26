//
//  CreationViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 21.04.2025.
//

import UIKit

class CreationViewController: BaseViewController {

	private var trackerType: TrackerType
	private var selectedEmojiIndex: IndexPath?
	private var selectedColorIndex: IndexPath?
	private var selectedTracker: Tracker?
	private var isTextTooLong = false
	private var currentDate: Date?

	private let textField: UITextField = PaddedTextField(placeholder: "Введите название трекера")
	private let tableView = UITableView(frame: .zero, style: .plain)
	private let collectionView: UICollectionView
	private let cancelButton = AppButton(title: "Отмена", style: .outlined())
	private let saveButton = AppButton(title: "Сохранить")
	private var stackView: UIStackView!

	private lazy var collectionBlocks: [CollectionBlock] = [
		.textField,
		.trackerOptions(trackerOptions),
		.emoji([
			"🙂", "😻", "🌺", "🐶", "❤️", "😱",
			"😇", "😡", "🥶", "🤔", "🙌", "🍔",
			"🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
		]),
		.color([
			.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemTeal,
			.systemPink, .systemCyan, .systemYellow, .systemBrown, .systemIndigo, .systemMint,
			.systemRed.withAlphaComponent(0.5), .systemBlue.withAlphaComponent(0.5), .systemGreen.withAlphaComponent(0.5),
			.systemOrange.withAlphaComponent(0.5), .systemPurple.withAlphaComponent(0.5), .systemTeal.withAlphaComponent(0.5)
		])
	]

	private var categories: [TrackerCategory] = []
	private var selectedCategory: TrackerCategory?
	private var weekDays: Set<WeekDay>?
	private var daysString: String {
		get {
			guard let weekDays else { return "" }
			return Array(weekDays)
				.sorted(by: { $0.rawValue < $1.rawValue })
				.map { $0.short }
				.joined(separator: ", ")
		}
	}

	private lazy var trackerOptions: [TrackerOption] = []


	var delegate: CreationViewControllerDelegate?

	init(
		type: TrackerType,
		categories: [TrackerCategory]? = nil,
		selectedTracker: Tracker? = nil,
		selectedCategory: TrackerCategory? = nil,
		currentDate: Date? = nil
	) {
		if let categories {
			self.categories = categories
		}
		if let selectedCategory {
			self.selectedCategory = selectedCategory
		}
		if let selectedTracker {
			self.selectedTracker = selectedTracker
			self.weekDays = selectedTracker.schedule
			self.textField.text = selectedTracker.name
		}
		self.trackerType = type
		self.currentDate = currentDate

		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: 52, height: 52)
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

		super.init(nibName: nil, bundle: nil)
	}

	private func getIndexPath(for color: UIColor) -> IndexPath? {
		guard let sectionIndex = collectionBlocks.firstIndex(where: {
			if case .color = $0 { return true }
			return false
		}) else { return nil }

		guard case .color(let colors) = collectionBlocks[sectionIndex],
			  let index = colors.firstIndex(of: color) else { return nil }
		
		return IndexPath(item: index, section: sectionIndex)
	}

	private func getIndexPath(for emoji: String) -> IndexPath? {
		guard let sectionIndex = collectionBlocks.firstIndex(where: {
			if case .emoji = $0 { return true }
			return false
		}) else { return nil }

		guard case .emoji(let emojis) = collectionBlocks[sectionIndex],
			  let index = emojis.firstIndex(of: emoji) else { return nil }

		return IndexPath(item: index, section: sectionIndex)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		trackerOptions.append(
			TrackerOption(title: "Категория", value: selectedCategory?.title) 	{ [weak self] in
				guard let self else { return UIViewController() }
				let vc = CategorySelectionViewController(categories: self.categories, selectedCategory: selectedCategory)
				vc.delegate = self
				return vc
			}
		)
		if trackerType == .habit {
			trackerOptions.append(
				TrackerOption(title: "Расписание", value: daysString) { [weak self] in
					guard let self else { return UIViewController() }
					let vc = ScheduleViewController(days: self.weekDays)
					vc.delegate = self
					return vc
				}
			)
		}
		if let selectedTracker {
			selectedColorIndex = getIndexPath(for: selectedTracker.color)
			selectedEmojiIndex = getIndexPath(for: selectedTracker.emoji)
		}

		setupUI()
		layoutUI()
		screenTitle = "Создание трекера"
	}

	func addTracker(_ tracker: Tracker, toCategory category: TrackerCategory?) {
		guard
			let category,
			let index = categories.firstIndex(where: { $0.title == category.title }) else {
			print("Категория не найдена")
			return
		}

		let oldCategory = categories[index]
		let updatedCategory = TrackerCategory(
			title: oldCategory.title,
			trackers: oldCategory.trackers + [tracker]
		)

		categories[index] = updatedCategory
	}

	func updateTracker(_ updatedTracker: Tracker, inCategory category: TrackerCategory?) {
		guard
			let category,
			let categoryIndex = categories.firstIndex(where: { $0.title == category.title }) else {
			print("Категория не найдена")
			return
		}

		var trackers = categories[categoryIndex].trackers

		guard let trackerIndex = trackers.firstIndex(where: { $0.id == updatedTracker.id }) else {
			print("Трекер не найден в категории")
			return
		}

		trackers[trackerIndex] = updatedTracker

		let updatedCategory = TrackerCategory(
			title: category.title,
			trackers: trackers
		)

		categories[categoryIndex] = updatedCategory
	}

	private func validateForm() {
		let isTextFieldFilled = !(textField.text?.isEmpty ?? true)
		let isCategorySelected = selectedCategory != nil
		let isScheduleSelected = !(weekDays?.isEmpty ?? true) || trackerType == .nonRegular
		let isColorSelected = selectedColorIndex != nil
		let isEmojiSelected = selectedEmojiIndex != nil

		let isFormValid = isTextFieldFilled && isCategorySelected
		&& isScheduleSelected && isColorSelected && isEmojiSelected && !isTextTooLong

		saveButton.isEnabled = isFormValid
	}

	private func setupUI() {

		textField.addAction(UIAction { [weak self] _ in
			let textCount = self?.textField.text?.count ?? 0
			let nowTooLong = textCount > 38

			if nowTooLong != self?.isTextTooLong {
				self?.isTextTooLong = nowTooLong


				if let index = self?.collectionBlocks.firstIndex(where: { if case .textField = $0 { return true } else { return false } }),
				   let cell = self?.collectionView.cellForItem(at: IndexPath(item: 0, section: index)) as? TextFieldCell {
					cell.updateWarningLabel(isHidden: !nowTooLong)
				}

				self?.collectionView.performBatchUpdates(nil)
			}
			self?.validateForm()
		}, for: .editingChanged)

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(TrackerCreationTableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.isScrollEnabled = false
		tableView.backgroundColor = .ypCellBack
		tableView.layer.cornerRadius = 16
		tableView.clipsToBounds = true

		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.backgroundColor = .clear
		collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
		collectionView.register(TrackerOptionsCell.self, forCellWithReuseIdentifier: TrackerOptionsCell.reuseIdentifier)
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
		collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
		collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")

		stackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
		stackView.axis = .horizontal
		stackView.spacing = 8
		stackView.distribution = .fillEqually

		cancelButton.addAction(UIAction { [weak self] _ in
			guard let self else { return }
			self.dismissRoot()
		}, for: .touchUpInside)
		saveButton.addAction(
			UIAction { [weak self] _ in
				guard let self else { return }
				if let selectedTracker {
					// TODO: - добавить реализацию редактирования
//					guard let selectedColorIndex = self.selectedColorIndex,
//						  let selectedEmojiIndex = self.selectedEmojiIndex,
//						  case let .color(colors) = self.collectionBlocks[selectedColorIndex.section],
//						  case let .emoji(emojis) = self.collectionBlocks[selectedEmojiIndex.section]
//					else { return }
//					let tracker = Tracker(
//						id: selectedTracker.id,
//						name: self.textField.text ?? "",
//						color: colors[selectedColorIndex.row],
//						emoji: emojis[selectedEmojiIndex.row],
//						schedule: self.weekDays
//					)
//					updateTracker(tracker, inCategory: self.selectedCategory)
				} else {
					guard let selectedColorIndex = self.selectedColorIndex,
						  let selectedEmojiIndex = self.selectedEmojiIndex,
						  case let .color(colors) = self.collectionBlocks[selectedColorIndex.section],
						  case let .emoji(emojis) = self.collectionBlocks[selectedEmojiIndex.section]
					else { return }
					let tracker = Tracker(
						name: self.textField.text ?? "",
						color: colors[selectedColorIndex.row],
						emoji: emojis[selectedEmojiIndex.row],
						schedule: trackerType == .habit ? self.weekDays : nil,
						date: trackerType == .nonRegular ? currentDate : nil
					)
					self.addTracker(tracker, toCategory: self.selectedCategory)
				}
				self.delegate?.didCreateTrackerAndUpdate(categories: self.categories)
				self.dismissRoot()
			},
			for: .touchUpInside)

		[
			//			textField, tableView,
			collectionView, stackView].forEach { view in
				view.translatesAutoresizingMaskIntoConstraints = false
				self.view.addSubview(view)
			}
		validateForm()
	}

	private func layoutUI() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),

			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			stackView.heightAnchor.constraint(equalToConstant: 60)
		])
	}

	private func dismissRoot() {
		var root = presentingViewController
		while let parent = root?.presentingViewController {
			root = parent
		}
		root?.dismiss(animated: true)
	}
}

// MARK: - Schedule View Delegate

extension CreationViewController: ScheduleViewControllerDelegate {
	func didSelectDays(_ days: Set<WeekDay>) {
		self.weekDays = days
		trackerOptions[1].value = daysString
		tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
		validateForm()
	}
}

// MARK: - Category View Delegate

extension CreationViewController: CategorySelectionDelegate {
	func didSelectCategory(_ category: TrackerCategory, _ categories: [TrackerCategory]) {
		trackerOptions[0].value = category.title
		tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
		self.selectedCategory = category
		self.categories = categories
		validateForm()
	}
}

// MARK: - TableView DataSource & Delegate

extension CreationViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		trackerOptions.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		var conf = cell.defaultContentConfiguration()
		conf.text = trackerOptions[indexPath.row].title
		if let description = trackerOptions[indexPath.row].value {
			conf.secondaryText = description
		}
		conf.textProperties.font = .systemFont(ofSize: 17, weight: .regular)
		conf.textProperties.color = .black
		conf.secondaryTextProperties.font = .systemFont(ofSize: 17, weight: .regular)
		conf.secondaryTextProperties.color = .ypGray
		cell.contentConfiguration = conf
		if indexPath.row == trackerOptions.count - 1 {
			cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
		} else {
			cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		}
		cell.accessoryType = .disclosureIndicator
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = trackerOptions[indexPath.row].controllerProvider()
		present(vc, animated: true)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Constants.tableViewCellHeight
	}
}

// MARK: - CollectionView DataSource & Delegate

extension CreationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	// MARK: Section - колличество

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return collectionBlocks.count
	}

	// MARK: Cell - колличество

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionBlocks[section].itemsCount
	}

	// MARK: Cell

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let block = collectionBlocks[indexPath.section]
		let resultCell: UICollectionViewCell

		switch block {
			case .textField:
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: TextFieldCell.reuseIdentifier,
					for: indexPath
				) as? TextFieldCell else {
					return UICollectionViewCell()
				}
				cell.configure(with: textField)
				resultCell = cell

			case .trackerOptions:
				guard let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: TrackerOptionsCell.reuseIdentifier,
					for: indexPath
				) as? TrackerOptionsCell else {
					return UICollectionViewCell()
				}
				cell.configure(with: tableView)
				resultCell = cell

			case .emoji(let emojis):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath)
				cell.contentView.subviews.forEach { $0.removeFromSuperview() }

				let label = UILabel()
				label.text = emojis[indexPath.item]
				label.font = .systemFont(ofSize: 30)
				label.translatesAutoresizingMaskIntoConstraints = false
				cell.contentView.addSubview(label)
				NSLayoutConstraint.activate([
					label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
					label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
				])

				cell.contentView.backgroundColor = (selectedEmojiIndex == indexPath) ? UIColor.systemGray4 : .clear
				cell.contentView.layer.cornerRadius = 8
				cell.contentView.layer.masksToBounds = true

				resultCell = cell

			case .color(let colors):
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else {
					return UICollectionViewCell()
				}
				cell.configure(with: colors[indexPath.item], isSelected: indexPath == selectedColorIndex)
				resultCell = cell
		}

		//		resultCell.layer.borderWidth = 1
		//		resultCell.layer.borderColor = UIColor.red.cgColor
		return resultCell
	}

	//MARK: Cell - didSelect

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch collectionBlocks[indexPath.section] {
			case .emoji:
				selectedEmojiIndex = indexPath
				collectionView.reloadData()
				validateForm()
			case .color:
				selectedColorIndex = indexPath
				collectionView.reloadData()
				validateForm()
			default:
				break
		}
	}

	// MARK: Layout - размеры ячейки

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let block = collectionBlocks[indexPath.section]

		switch block {
			case .textField:
				let textCount = textField.text?.count ?? 0
				let height = textCount > 38 ? Constants.commonHeight + 30 : Constants.commonHeight
				return CGSize(width: collectionView.bounds.width, height: height)

			case .trackerOptions(let options):
				return CGSize(width: collectionView.bounds.width, height: Constants.commonHeight * CGFloat(options.count))

			case .emoji, .color:
				return CGSize(width: 52, height: 52)
		}
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard kind == UICollectionView.elementKindSectionHeader,
			  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeaderView else {
			return UICollectionReusableView()
		}
		header.configure(with: collectionBlocks[indexPath.section].name)
		return header
	}

	// MARK: Section - размеры заголовка

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		let title = collectionBlocks[section].name
		if title.isEmpty {
			return .zero
		} else {
			return CGSize(width: collectionView.bounds.width, height: 50)
		}
	}

	// MARK: Layout - отступы

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		switch collectionBlocks[section] {
			case .textField, .trackerOptions:
				UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
			case .color, .emoji:
				UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
		}
	}
}
