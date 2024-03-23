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
    private let iconImageView = UIImageView()
    
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
        backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.layer.cornerRadius = 30
        configureBuildingNameLabel()
        configureWorkHoursLabel()
        configureAddressLabel()
        configureIconImageView()
    }
    
    private func configureBuildingNameLabel() {
        self.addSubview(buildingNameLabel)
        buildingNameLabel.pinTop(to: self.topAnchor, 25)
        buildingNameLabel.pinLeft(to: self.leadingAnchor, 65)
        buildingNameLabel.numberOfLines = 0
        buildingNameLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        buildingNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private func configureWorkHoursLabel() {
        self.addSubview(workHoursLabel)
        workHoursLabel.pinTop(to: buildingNameLabel.bottomAnchor, 15)
        workHoursLabel.pinLeft(to: self.leadingAnchor, 65)
        workHoursLabel.numberOfLines = 0
        workHoursLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        workHoursLabel.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private func configureAddressLabel() {
        self.addSubview(addressLabel)
        addressLabel.pinTop(to: workHoursLabel.bottomAnchor, 5)
        addressLabel.pinLeft(to: self.leadingAnchor, 65)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        addressLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureIconImageView() {
        self.addSubview(iconImageView)
        iconImageView.pinCenterY(to: self.buildingNameLabel.centerYAnchor)
        iconImageView.pinLeft(to: self.leadingAnchor, 20)
        iconImageView.image = UIImage(systemName: "building.2", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        iconImageView.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        iconImageView.backgroundColor = UIColor.clear
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

