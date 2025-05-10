//
//  CreationViewPresenter.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 10.05.2025.
//

protocol CreationViewPresenterProtocol: AnyObject {
	var trackerOptions: [TrackerOption] { get set }
	var collectionBlocks: [CollectionBlock] { get }
}

final class CreationViewPresenter: CreationViewPresenterProtocol {
	lazy var trackerOptions: [TrackerOption] = []
	lazy var collectionBlocks: [CollectionBlock] = [
		.textField,
		.trackerOptions(trackerOptions),
		.emoji([
			"🙂", "😻", "🌺", "🐶", "❤️", "😱",
			"😇", "😡", "🥶", "🤔", "🙌", "🍔",
			"🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
		]),
		.color([
			.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemTeal,
			.systemPink, .ypCellBack, .systemYellow, .systemBrown, .systemIndigo, .ypBlue,
			.systemRed.withAlphaComponent(0.5), .systemBlue.withAlphaComponent(0.5), .systemGreen.withAlphaComponent(0.5),
			.systemOrange.withAlphaComponent(0.5), .systemPurple.withAlphaComponent(0.5), .systemTeal.withAlphaComponent(0.5)
		])
	]
}
