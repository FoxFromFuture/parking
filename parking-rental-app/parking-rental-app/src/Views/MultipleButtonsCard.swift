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
        backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
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
        button.configure(title: title, activeValue: activeValue, action: action)
        buttonsStackView.addArrangedSubview(button)
        button.pinHorizontal(to: self.buttonsStackView)
    }
}
