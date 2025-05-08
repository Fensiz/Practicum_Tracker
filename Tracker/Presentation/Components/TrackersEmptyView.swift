//
//  TrackersEmptyView.swift
//  Tracker
//
//  Created by Симонов Иван Дмитриевич on 23.04.2025.
//


import UIKit

final class TrackersEmptyView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let imageView: UIImageView = {
        let emoji = "💫"
        let emojiImage = ImageUtils.emojiToGrayscaleImage(emoji: emoji, font: .systemFont(ofSize: 60))
        let imageView = UIImageView(image: emojiImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
	init(text: String) {
		super.init(frame: .zero)
        setup(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
	private func setup(text: String = "") {
		label.text = text

        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
