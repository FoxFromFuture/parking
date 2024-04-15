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
    private let topBorderView = UIView()
    
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
        backgroundColor = Colors.tabBar.uiColor
        configureTopBorderView()
        configureHomeButton()
        configureMoreButton()
        configureImageViewsStack()
    }
    
    private func configureTopBorderView() {
        self.addSubview(topBorderView)
        topBorderView.pinTop(to: self.topAnchor)
        topBorderView.pinLeft(to: self.leadingAnchor)
        topBorderView.pinRight(to: self.trailingAnchor)
        topBorderView.setHeight(0.5)
        topBorderView.backgroundColor = Colors.tabBarTopBorder.uiColor
    }
    
    private func configureHomeButton() {
        let image = UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        homeButton.setText("home".localize(), UIColor(named: "Active") ?? .blue, .systemFont(ofSize: 12, weight: .medium))
        homeButton.setIcon(image, UIColor(named: "Active") ?? .blue)
    }
    
    private func configureMoreButton() {
        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        moreButton.setText("more".localize(), UIColor(named: "Icon") ?? .gray, .systemFont(ofSize: 12, weight: .medium))
        moreButton.setIcon(image, UIColor(named: "Icon") ?? .gray)
    }
    
    public func setHomeButtonAction(action: @escaping (() -> Void)) {
        homeButton.pressAction = action
    }
    
    public func setMoreButtonAction(action: @escaping (() -> Void)) {
        moreButton.pressAction = action
    }
    
    public func setHomeButtonActive() {
        var image = UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        homeButton.setText("home".localize(), UIColor(named: "Active") ?? .blue, .systemFont(ofSize: 12, weight: .medium))
        homeButton.setIcon(image, UIColor(named: "Active") ?? .blue)
        image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        moreButton.setText("more".localize(), UIColor(named: "Icon") ?? .gray, .systemFont(ofSize: 12, weight: .medium))
        moreButton.setIcon(image, UIColor(named: "Icon") ?? .gray)
    }
    
    public func setMoreButtonActive() {
        var image = UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        homeButton.setText("home".localize(), UIColor(named: "Icon") ?? .gray, .systemFont(ofSize: 12, weight: .medium))
        homeButton.setIcon(image, UIColor(named: "Icon") ?? .gray)
        image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        moreButton.setText("more".localize(), UIColor(named: "Active") ?? .blue, .systemFont(ofSize: 12, weight: .medium))
        moreButton.setIcon(image, UIColor(named: "Active") ?? .blue)
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

