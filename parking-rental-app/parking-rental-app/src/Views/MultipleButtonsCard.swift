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
        configureButtonsStackView()
    }
    
    private func configureButtonsStackView() {
        self.addSubview(buttonsStackView)
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .equalCentering
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 0
        buttonsStackView.pin(to: self)
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
}
