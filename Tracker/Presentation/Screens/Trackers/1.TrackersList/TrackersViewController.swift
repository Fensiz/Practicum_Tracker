//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 20.04.2025.
//

import UIKit

final class TrackersViewController: UIViewController {

	// MARK: - Properties

	private var presenter: TrackersPresenterProtocol

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
		collectionView.dataSource = self
		collectionView.delegate = self
		return collectionView
	}()

	private let dummyView = TrackersEmptyView(text: "Что будем отслеживать?")

	// MARK: - Init

	init(presenter: TrackersPresenterProtocol = TrackersPresenter()) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupNavigationBar()
		setupBindings()
		updateEmptyState()
	}

	// MARK: - Private Methods

	private func setupUI() {
		title = "Трекеры"
		view.addSubview(dummyView)
		view.addSubview(collectionView)

		dummyView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			dummyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			dummyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.prefersLargeTitles = true

		let addAction = UIAction { [weak self] _ in
			self?.showTrackerTypeSelection()
		}
		navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
		navigationItem.leftBarButtonItem?.tintColor = .black

		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.preferredDatePickerStyle = .compact
		datePicker.addAction(UIAction { [weak self] _ in
			self?.presenter.updateDate(datePicker.date)
		}, for: .valueChanged)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)

		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "Поиск"
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchResultsUpdater = self
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	private func setupBindings() {
		presenter.onChange = { [weak self] in
			self?.updateEmptyState()
			self?.collectionView.reloadData()
		}
	}

	private func updateEmptyState() {
		dummyView.isHidden = !presenter.visibleTrackers.isEmpty
	}

	private func showTrackerTypeSelection() {
		let formVC = TrackerTypeSelectionViewController()
		formVC.delegate = self
		present(formVC, animated: true)
	}
}

// MARK: - TrackerTypeSelectionDelegate

extension TrackersViewController: TrackerTypeSelectionDelegate {
	func didSelectTrackerType(_ type: TrackerType, vc: UIViewController) {
		let formVC = CreationViewController(
			type: type,
			categories: presenter.categories
		)
		formVC.delegate = self
		vc.present(formVC, animated: true)
	}
}

// MARK: - CreationViewControllerDelegate

extension TrackersViewController: CreationViewControllerDelegate {
	func didCreateTrackerAndUpdate(categories: [TrackerCategory]) {
		presenter.updateCategories(categories)
	}
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		presenter.updateSearchText(searchController.searchBar.text ?? "")
	}
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		presenter.visibleTrackers.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		presenter.visibleTrackers[section].trackers.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: TrackerCell.reuseIdentifier,
			for: indexPath
		) as? TrackerCell else {
			return UICollectionViewCell()
		}

		let tracker = presenter.visibleTrackers[indexPath.section].trackers[indexPath.item]
		let isCompleted = presenter.isTrackerCompleted(tracker)
		let count = presenter.completedCount(for: tracker)

		cell.configure(
			with: tracker,
			count: count,
			action: { [weak self] in
				self?.presenter.toggleCompletion(for: tracker)
				self?.collectionView.reloadItems(at: [indexPath])
			},
			isCompleted: isCompleted
		)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard kind == UICollectionView.elementKindSectionHeader,
			  let header = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: SectionHeaderView.identifier,
				for: indexPath
			  ) as? SectionHeaderView else {
			return UICollectionReusableView()
		}
		let sectionTitle = presenter.visibleTrackers[indexPath.section].title
		header.configure(with: sectionTitle)
		return header
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width - 42) / 2
		return CGSize(width: width, height: 148)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		9
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		CGSize(width: collectionView.bounds.width, height: 36)
	}
}
