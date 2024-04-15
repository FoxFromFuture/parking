//
//  BuildingCell.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/14/24.
//

import UIKit

// MARK: - BuildingCell
final class BuildingCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private let buildingNameLabel = UILabel()
    private let workHoursLabel = UILabel()
    private let addressLabel = UILabel()
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
        self.backgroundColor = Colors.cardView.uiColor
        self.layer.shadowColor = Colors.cardViewShadow.uiColor.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 20
        self.layer.cornerRadius = 30
        configureBuildingNameLabel()
        configureWorkHoursLabel()
        configureAddressLabel()
        configureLeftIconImageView()
        configureRightIconImageView()
    }
    
    private func configureBuildingNameLabel() {
        self.addSubview(buildingNameLabel)
        buildingNameLabel.pinTop(to: self.topAnchor, 25)
        buildingNameLabel.pinLeft(to: self.leadingAnchor, 65)
        buildingNameLabel.numberOfLines = 0
        buildingNameLabel.textColor = Colors.mainText.uiColor
        buildingNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private func configureWorkHoursLabel() {
        self.addSubview(workHoursLabel)
        workHoursLabel.pinTop(to: buildingNameLabel.bottomAnchor, 10)
        workHoursLabel.pinLeft(to: self.leadingAnchor, 65)
        workHoursLabel.numberOfLines = 0
        workHoursLabel.textColor = Colors.mainText.uiColor
        workHoursLabel.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private func configureAddressLabel() {
        self.addSubview(addressLabel)
        addressLabel.pinTop(to: workHoursLabel.bottomAnchor)
        addressLabel.pinLeft(to: self.leadingAnchor, 65)
        addressLabel.pinRight(to: self.trailingAnchor, 65)
        addressLabel.numberOfLines = 1
        addressLabel.textColor = Colors.mainText.uiColor
        addressLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureLeftIconImageView() {
        self.addSubview(leftIconImageView)
        leftIconImageView.pinCenterY(to: self.buildingNameLabel.centerYAnchor)
        leftIconImageView.pinLeft(to: self.leadingAnchor, 20)
        leftIconImageView.image = UIImage(systemName: "building.2", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        leftIconImageView.tintColor = Colors.active.uiColor
        leftIconImageView.backgroundColor = .clear
    }
    
    private func configureRightIconImageView() {
        self.addSubview(rightIconImageView)
        rightIconImageView.pinCenterY(to: self.centerYAnchor)
        rightIconImageView.pinRight(to: self.trailingAnchor, 30)
        rightIconImageView.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)) ?? UIImage()
        rightIconImageView.tintColor = Colors.icon.uiColor
        rightIconImageView.backgroundColor = .clear
    }
    
    // MARK: - Override Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        buildingNameLabel.text = nil
        workHoursLabel.text = nil
        addressLabel.text = nil
    }
    
    // MARK: - Internal Methods
    func configure(buildingName: String, workHours: String, address: String) {
        buildingNameLabel.text = buildingName
        workHoursLabel.text = workHours
        addressLabel.text = address
    }
}

