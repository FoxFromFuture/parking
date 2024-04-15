//
//  MultipleButtonsCardButtonButton.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

// MARK: - MultipleButtonsCardButton
final class MultipleButtonsCardButton: UIView {
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let activeValueLabel = UILabel()
    private let arrowIconImageView = UIImageView()
    
    public var tapAction: (() -> Void)?
    
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
        backgroundColor = Colors.multipleButtonsCardView.uiColor
        self.layer.cornerRadius = 30
        self.setHeight(80)
        configureTitleLabel()
        configureArrowIconImageView()
        configureActiveValueLabel()
        configureTapAction()
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.pinCenterY(to: self.centerYAnchor)
        titleLabel.pinLeft(to: self.leadingAnchor, 30)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureArrowIconImageView() {
        self.addSubview(arrowIconImageView)
        arrowIconImageView.pinCenterY(to: self.centerYAnchor)
        arrowIconImageView.pinRight(to: self.trailingAnchor, 30)
        arrowIconImageView.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .small)) ?? UIImage()
        arrowIconImageView.tintColor = Colors.icon.uiColor
        arrowIconImageView.backgroundColor = UIColor.clear
    }
    
    private func configureActiveValueLabel() {
        self.addSubview(activeValueLabel)
        activeValueLabel.pinCenterY(to: self.centerYAnchor)
        activeValueLabel.pinRight(to: self.arrowIconImageView.leadingAnchor, 20)
        activeValueLabel.numberOfLines = 0
        activeValueLabel.textColor = Colors.secondaryText.uiColor
        activeValueLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureTapAction() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.MultipleButtonsCardButtonWasPressed(_:))
        )
        addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Internal Methods
    func configure(title: String, activeValue: String, action: @escaping (() -> Void)) {
        titleLabel.text = title
        activeValueLabel.text = activeValue
        self.tapAction = action
    }
    
    func setActiveValue(activeValue: String) {
        activeValueLabel.text = activeValue
    }
    
    // MARK: - Actions
    @objc
    private func MultipleButtonsCardButtonWasPressed(
        _ sender: UITapGestureRecognizer? = nil
    ) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.tapAction?()
    }
}
