//
//  TabBar.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/26/24.
//

import UIKit

// MARK: - TabBar
final class TabBar: UIView {
    
    // MARK: - Private Properties
    private let imageViewsStack = UIStackView()
    private let homeButton = TabBarButton()
    private let moreButton = TabBarButton()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureTabBar()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureTabBar() {
        self.layer.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        configureHomeButton()
        configureMoreButton()
        configureImageViewsStack()
    }
    
    private func configureHomeButton() {
        let image = UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        homeButton.setText("Home", #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), .systemFont(ofSize: 12, weight: .medium))
        homeButton.setIcon(image, #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
    }
    
    private func configureMoreButton() {
        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        moreButton.setText("More", #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1), .systemFont(ofSize: 12, weight: .medium))
        moreButton.setIcon(image, #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1))
    }
    
    public func setHomeButtonAction(action: @escaping (() -> Void)) {
        homeButton.pressAction = action
    }
    
    public func setMoreButtonAction(action: @escaping (() -> Void)) {
        moreButton.pressAction = action
    }
    
    public func setHomeButtonActive() {
        var image = UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        homeButton.setText("Home", #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), .systemFont(ofSize: 12, weight: .medium))
        homeButton.setIcon(image, #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
        image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        moreButton.setText("More", #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1), .systemFont(ofSize: 12, weight: .medium))
        moreButton.setIcon(image, #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1))
    }
    
    public func setMoreButtonActive() {
        var image = UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        homeButton.setText("Home", #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1), .systemFont(ofSize: 12, weight: .medium))
        homeButton.setIcon(image, #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1))
        image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        moreButton.setText("More", #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), .systemFont(ofSize: 12, weight: .medium))
        moreButton.setIcon(image, #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
    }
    
    private func configureImageViewsStack() {
        addSubview(imageViewsStack)
        imageViewsStack.alignment = .center
        imageViewsStack.distribution = .equalCentering
        imageViewsStack.axis = .horizontal
        imageViewsStack.pinTop(to: self.topAnchor, 25)
        imageViewsStack.pinLeft(to: self.leadingAnchor, 80)
        imageViewsStack.pinRight(to: self.trailingAnchor, 80)
        imageViewsStack.addArrangedSubview(homeButton)
        imageViewsStack.addArrangedSubview(moreButton)
    }
}

