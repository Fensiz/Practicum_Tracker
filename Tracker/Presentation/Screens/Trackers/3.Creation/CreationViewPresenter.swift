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
			#colorLiteral(red: 0.9921568627, green: 0.2980392157, blue: 0.2862745098, alpha: 1), #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.2666666667, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2, green: 0.8117647059, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.4274509804, blue: 0.831372549, alpha: 1),
			#colorLiteral(red: 0.9764705882, green: 0.831372549, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6549019608, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.9019607843, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.2078431373, green: 0.2039215686, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 1, green: 0.4039215686, blue: 0.3019607843, alpha: 1), #colorLiteral(red: 1, green: 0.6, blue: 0.8, alpha: 1),
			#colorLiteral(red: 0.9647058824, green: 0.768627451, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.5803921569, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.6784313725, green: 0.337254902, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.4470588235, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.1843137255, green: 0.8156862745, blue: 0.3450980392, alpha: 1),
		])
	]
}
