//
//  MultipleButtonsCard.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

// MARK: - MultipleButtonsCard
final class MultipleButtonsCard: UIView {
    
    // MARK: - Private Properties
    private let buttonsStackView = UIStackView()
    private var buttons: [MultipleButtonsCardButton] = []
    private let titleLabel = UILabel()
    private let bottomLabel = UILabel()
    
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
        configureTitleLabel()
        configureButtonsStackView()
        configureBottomLabel()
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.pinTop(to: self.topAnchor, 20)
        titleLabel.pinLeft(to: self.leadingAnchor, 30)
        titleLabel.pinRight(to: self.trailingAnchor, 30)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 28, weight: .semibold)
    }
    
    private func configureButtonsStackView() {
        self.addSubview(buttonsStackView)
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .equalCentering
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 0
        buttonsStackView.pinTop(to: self.titleLabel.bottomAnchor)
        buttonsStackView.pinHorizontal(to: self)
    }
    
    private func configureBottomLabel() {
        self.addSubview(bottomLabel)
        bottomLabel.pinTop(to: buttonsStackView.bottomAnchor, -10)
        bottomLabel.pinLeft(to: self.leadingAnchor, 30)
        bottomLabel.pinRight(to: self.trailingAnchor, 30)
        bottomLabel.pinBottom(to: self.bottomAnchor, 20)
        bottomLabel.numberOfLines = 0
        bottomLabel.textColor = Colors.secondaryText.uiColor
        bottomLabel.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    // MARK: - Internal Methods
    func addButton(title: String, activeValue: String, action: @escaping (() -> Void)) {
        let button = MultipleButtonsCardButton()
        self.buttons.append(button)
        button.configure(title: title, activeValue: activeValue, action: action)
        buttonsStackView.addArrangedSubview(button)
        button.pinHorizontal(to: self.buttonsStackView)
    }
    
    func setActiveValue(_ buttonIdx: Int, activeValue: String) {
        buttons[buttonIdx].setActiveValue(activeValue: activeValue)
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func setBottomText(text: String) {
        self.bottomLabel.text = text
    }
    
    func deleteTitle() {
        self.titleLabel.removeFromSuperview()
        self.buttonsStackView.pinTop(to: self.topAnchor)
    }
    
    func deleteBottomText() {
        self.bottomLabel.removeFromSuperview()
        self.buttonsStackView.pinBottom(to: self.bottomAnchor)
    }
}
