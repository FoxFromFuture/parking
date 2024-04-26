//
//  CarCell.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

import UIKit

// MARK: - CarCell
final class CarCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let leftIconImageView = UIImageView()
    private let rightIconImageView = UIImageView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        self.backgroundColor = Colors.background.uiColor
        configureLeftIconImageView()
        configureTitleLabel()
        configureRightIconImageView()
    }
    
    private func configureLeftIconImageView() {
        self.addSubview(leftIconImageView)
        leftIconImageView.pinCenterY(to: self.centerYAnchor)
        leftIconImageView.pinCenterX(to: self.leadingAnchor, 30)
        leftIconImageView.tintColor = Colors.active.uiColor
        leftIconImageView.backgroundColor = UIColor.clear
        leftIconImageView.image = UIImage(systemName: "car.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
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
        rightIconImageView.pinRight(to: self.trailingAnchor, 30)
        rightIconImageView.tintColor = Colors.icon.uiColor
        rightIconImageView.backgroundColor = UIColor.clear
        rightIconImageView.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
    }
    
    // MARK: - Override Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Internal Methods
    func configure(model: String, registryNumber: String) {
        titleLabel.text = "\(model) (\(registryNumber))"
    }
}
