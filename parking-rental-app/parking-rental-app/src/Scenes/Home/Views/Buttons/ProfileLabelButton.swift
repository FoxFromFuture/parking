//
//  ProfileLabelButton.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

class ProfileLabelButton: UIView {
    
    public var pressAction: (() -> Void)?

    private let textLabel = UILabel()
    private let leftIconView = UIImageView()
    private let rightIconView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(
        _ text: String,
        _ color: UIColor,
        _ font: UIFont
    ) {
        textLabel.text = text
        textLabel.textColor = color
        textLabel.textAlignment = .center
        textLabel.font = font
    }
    
    func setLeftIcon(_ image: UIImage, _ tintColor: UIColor) {
        leftIconView.image = image
        leftIconView.tintColor = tintColor
        leftIconView.backgroundColor = UIColor.clear
        leftIconView.setHeight(34)
        leftIconView.setWidth(38)
    }
    
    func setRightIcon(_ image: UIImage, _ tintColor: UIColor) {
        rightIconView.image = image
        rightIconView.tintColor = tintColor
        rightIconView.backgroundColor = UIColor.clear
    }
    
    func configureUI() {
        self.backgroundColor = .clear
        self.setHeight(40)
        self.setWidth(160)
        self.addSubview(leftIconView)
        leftIconView.pinLeft(to: self.leadingAnchor)
        leftIconView.pinCenterY(to: self.centerYAnchor)
        self.addSubview(textLabel)
        textLabel.pinLeft(to: self.leftIconView.trailingAnchor, 12)
        textLabel.pinCenterY(to: self.centerYAnchor)
        self.addSubview(rightIconView)
        rightIconView.pinLeft(to: self.textLabel.trailingAnchor, 12)
        rightIconView.pinCenterY(to: self.centerYAnchor)
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.TabBarButtonWasPressed(_:))
        )
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func TabBarButtonWasPressed(
        _ sender: UITapGestureRecognizer? = nil
    ) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.pressAction?()
    }
}

