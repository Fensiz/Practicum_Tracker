//
//  CategoryCell.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 26.05.2025.
//


import UIKit

final class CategoryCell: UITableViewCell {
	static let reuseIdentifier = "CategoryCell"

	func configure(with title: String, isSelected: Bool, isLast: Bool) {
		backgroundColor = .ypCellBack
		textLabel?.text = title
		accessoryType = isSelected ? .checkmark : .none
		separatorInset = isLast
			? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
			: UIEdgeInsets(top: 0, left: Constants.commonPadding, bottom: 0, right: Constants.commonPadding)
	}
}