//
//  ViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

import UIKit

class TrackersViewController: UIViewController {
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
		collectionView.register(
			SectionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SectionHeaderView.identifier
		)
		collectionView.backgroundColor = .clear
		collectionView.translatesAutoresizingMaskIntoConstraints = false
//		collectionView.layer.borderColor = UIColor.systemGray6.cgColor
//		collectionView.layer.borderWidth = 1
		collectionView.dataSource = self
		collectionView.delegate = self
		return collectionView
	}()

	private let dummyView = TrackersEmptyView(text: "Что будем отслеживать?")

	func addTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
		var updatedCategories: [TrackerCategory] = []

		for category in categories {
			if category.title == categoryTitle {
				var newTrackers = category.trackers
				newTrackers.append(tracker)
				let newCategory = TrackerCategory(title: category.title, trackers: newTrackers)
				updatedCategories.append(newCategory)
			} else {
				updatedCategories.append(category)
			}
		}

		categories = updatedCategories
	}

	var categories: [TrackerCategory] = [
		TrackerCategory(
			title: "Домашний уют",
			trackers: [
				Tracker(id: UUID(), name: "Поливать растения", color: .systemTeal, emoji: "😊", schedule: [.friday])
			]
		),
		TrackerCategory(
			title: "Радостные мелочи",
			trackers: [
				Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .ypRed, emoji: "😊", schedule: [.friday])
			]
		)
	]
	var completedTrackers: Set<TrackerRecord> = []
	var currentDate: Date = Date() {
		didSet {
			updateEmptyViewVisibility()
		}
	}

	private func updateEmptyViewVisibility() {
		let isEmpty = visibleTrackers.isEmpty
		dummyView.isHidden = !isEmpty
	}

	func toggleCompletion(for tracker: Tracker, on date: Date) {
		let record = TrackerRecord(id: tracker.id, date: date)
		if completedTrackers.contains(record) {
			completedTrackers.remove(record)
		} else {
			completedTrackers.insert(record)
		}
	}

	var visibleTrackers: [TrackerCategory] {
		let currentWeekDay = WeekDay.from(date: currentDate)

		return categories.compactMap { category in
			let trackersForDay = category.trackers.filter { tracker in
				guard let schedule = tracker.schedule else { return true } // нерегулярные
				return schedule.contains(currentWeekDay)
			}
			return trackersForDay.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackersForDay)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Трекеры"
		navigationController?.navigationBar.prefersLargeTitles = true

		//кнопка +
		let action = UIAction { [weak self] _ in
			let formVC = TrackerSelectionViewController()
			formVC.delegate = self

			self?.present(formVC, animated: true)
		}
		navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
		navigationItem.leftBarButtonItem?.tintColor = .black

		//date-picker
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.preferredDatePickerStyle = .compact
		let pickerAction = UIAction { [weak self] _ in
			self?.currentDate = datePicker.date
			self?.collectionView.reloadData()
			print("OK")
		}
		datePicker.addAction(pickerAction, for: .valueChanged)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)

		// поиск
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "Поиск"
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		navigationItem.searchController = searchController
		definesPresentationContext = true

		// collectionView
		dummyView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(dummyView)
		view.addSubview(collectionView)

		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			dummyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			dummyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])

		updateEmptyViewVisibility()
	}

	func isTrackerCompleted(_ tracker: Tracker) -> Bool {
		completedTrackers.contains(where: {
			$0.id == tracker.id &&
			Calendar.current.isDate($0.date, inSameDayAs: currentDate)
		})
	}
}

extension TrackersViewController: TrackerTypeSelectionDelegate {
	func didSelectTrackerType(_ type: TrackerType, vc: UIViewController) {
		let formVC = CreationViewController(
			type: type,
			categories: categories
		)
		formVC.delegate = self
		vc.present(formVC, animated: true)
	}
}

protocol CreationViewControllerDelegate: AnyObject {
	func didCreateTrackerAndUpdate(categories: [TrackerCategory])
}

// MARK: - CreationViewControllerDelegate

extension TrackersViewController: CreationViewControllerDelegate {
	func didCreateTrackerAndUpdate(categories: [TrackerCategory]) {
		self.categories = categories
		collectionView.reloadData()
	}
}

//protocol TrackerTypeSelectionDelegate: AnyObject {
//	func didSelectTrackerType(_ type: TrackerType)
//}


//extension TrackersViewController: UICollectionViewDataSource {
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		0
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		UICollectionViewCell()
//	}
//}


extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		guard
			kind == UICollectionView.elementKindSectionHeader,
			let header = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: SectionHeaderView.identifier,
				for: indexPath
			) as? SectionHeaderView else {
			return UICollectionReusableView()
		}

		let sectionTitle = categories[indexPath.section].title
		header.configure(with: sectionTitle)

		return header
	}
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 36)
	}


	func numberOfSections(in collectionView: UICollectionView) -> Int {
		visibleTrackers.count
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		visibleTrackers[section].trackers.count
//		categories[section].trackers.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell else {
			return UICollectionViewCell()
		}
		let tracker = visibleTrackers[indexPath.section].trackers[indexPath.item]
		let isCompleted = isTrackerCompleted(tracker)
		let count = completedTrackers.filter { $0.id == tracker.id }.count
		print(2, isCompleted)
		cell.configure(
			with: tracker,
			count: count,
			action: { [weak self] in
				guard let self else { return }
				self.toggleCompletion(for: tracker, on: self.currentDate)
				print(completedTrackers)
				self.collectionView.reloadItems(at: [indexPath])
			},
			isCompleted: isCompleted
		)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width - 42) / 2
		return CGSize(width: width, height: 148)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0 // отступ между строками
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 9 // отступ между элементами в строке
	}
}
