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
		layout.itemSize = CGSize(width: 100, height: 100)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.backgroundColor = .clear
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		collectionView.dataSource = self
		return collectionView
	}()

	private var dummyView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .equalCentering
		stackView.spacing = 8
		let label = UILabel()
		label.text = "Что будем отслеживать?"
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 12, weight: .medium)

		let emoji = "💫"
		let emojiImage = ImageUtils.emojiToGrayscaleImage(emoji: emoji, font: .systemFont(ofSize: 60))
		let imageView = UIImageView(image: emojiImage)
		imageView.translatesAutoresizingMaskIntoConstraints = false

		stackView.addArrangedSubview(imageView)
		stackView.addArrangedSubview(label)

		NSLayoutConstraint.activate([
				imageView.widthAnchor.constraint(equalToConstant: 80),
				imageView.heightAnchor.constraint(equalToConstant: 80),
		])

		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Трекеры"
		navigationController?.navigationBar.prefersLargeTitles = true

		//кнопка +
		navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: nil)
		navigationItem.leftBarButtonItem?.tintColor = .black

		// поиск
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "Поиск"
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		navigationItem.searchController = searchController
		definesPresentationContext = true

		// collectionView
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
	}
}

extension TrackersViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		UICollectionViewCell()
	}
}
