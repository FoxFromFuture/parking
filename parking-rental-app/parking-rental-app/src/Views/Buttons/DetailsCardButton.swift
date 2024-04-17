//
//  DetailsCardButton.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

// MARK: - DetailsCardButton
final class DetailsCardButton: UIView {
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let leftIconImageView = UIImageView()
    private let rightIconImageView = UIImageView()
    
    private var tapAction: (() -> Void)?
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        self.backgroundColor = Colors.background.uiColor
        self.setHeight(60)
        configureLeftIconImageView()
        configureTitleLabel()
        configureRightIconImageView()
        configureTapAction()
    }
    
    private func configureLeftIconImageView() {
        self.addSubview(leftIconImageView)
        leftIconImageView.pinCenterY(to: self.centerYAnchor)
        leftIconImageView.pinCenterX(to: self.leadingAnchor, 30)
        leftIconImageView.tintColor = Colors.active.uiColor
        leftIconImageView.backgroundColor = UIColor.clear
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.pinCenterY(to: self.centerYAnchor)
        titleLabel.pinLeft(to: self.leftIconImageView.centerXAnchor, 30)
        titleLabel.pinRight(to: self.trailingAnchor, 20)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureRightIconImageView() {
        self.addSubview(rightIconImageView)
        rightIconImageView.pinCenterY(to: self.centerYAnchor)
        rightIconImageView.pinCenterX(to: self.trailingAnchor, 30)
        rightIconImageView.tintColor = Colors.secondaryText.uiColor
        rightIconImageView.backgroundColor = UIColor.clear
        rightIconImageView.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
    }
    
    private func configureTapAction() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.DetailsCardButtonWasPressed(_:))
        )
        addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Internal Methods
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setLeftIcon(icon: String) {
        leftIconImageView.image = UIImage(systemName: "\(icon)") ?? UIImage()
    }
    
    func hideRightIcon() {
        self.rightIconImageView.removeFromSuperview()
    }
    
    func setAction(action: @escaping (() -> Void)) {
        self.tapAction = action
    }
    
    // MARK: - Actions
    @objc
    private func DetailsCardButtonWasPressed(
        _ sender: UITapGestureRecognizer? = nil
    ) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.tapAction?()
    }
}

