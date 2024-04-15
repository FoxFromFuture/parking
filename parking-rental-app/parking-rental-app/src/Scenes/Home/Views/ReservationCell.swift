//
//  ReservationCell.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

// MARK: - ReservationCell
final class ReservationCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private let lotNumberLabel = UILabel()
    private let dateLabel = UILabel()
    private let floorLabel = UILabel()
    private let buildingLabel = UILabel()
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
        self.backgroundColor = Colors.cardView.uiColor
        self.layer.shadowColor = Colors.cardViewShadow.uiColor.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 20
        self.layer.cornerRadius = 30
        configureLotNumberLabel()
        configureDateLabel()
        configureFloorLabel()
        configureBuildingLabel()
        configureIconImageView()
    }
    
    private func configureLotNumberLabel() {
        self.addSubview(lotNumberLabel)
        lotNumberLabel.pinTop(to: self.topAnchor, 25)
        lotNumberLabel.pinLeft(to: self.leadingAnchor, 30)
        lotNumberLabel.numberOfLines = 0
        lotNumberLabel.textColor = Colors.mainText.uiColor
        lotNumberLabel.font = .systemFont(ofSize: 28, weight: .semibold)
    }
    
    private func configureDateLabel() {
        self.addSubview(dateLabel)
        dateLabel.pinTop(to: self.lotNumberLabel.bottomAnchor, 10)
        dateLabel.pinLeft(to: self.leadingAnchor, 30)
        dateLabel.numberOfLines = 0
        dateLabel.textColor = Colors.mainText.uiColor
        dateLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureFloorLabel() {
        self.addSubview(floorLabel)
        floorLabel.pinTop(to: self.dateLabel.bottomAnchor, 10)
        floorLabel.pinLeft(to: self.leadingAnchor, 30)
        floorLabel.numberOfLines = 0
        floorLabel.textColor = Colors.secondaryText.uiColor
        floorLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureBuildingLabel() {
        self.addSubview(buildingLabel)
        buildingLabel.pinTop(to: self.floorLabel.bottomAnchor, 4)
        buildingLabel.pinLeft(to: self.leadingAnchor, 30)
        buildingLabel.pinBottom(to: self.bottomAnchor, 25)
        buildingLabel.numberOfLines = 0
        buildingLabel.textColor = Colors.secondaryText.uiColor
        buildingLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureIconImageView() {
        self.addSubview(iconImageView)
        iconImageView.pinCenterY(to: self.centerYAnchor)
        iconImageView.pinRight(to: self.trailingAnchor, 30)
        iconImageView.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)) ?? UIImage()
        iconImageView.tintColor = Colors.icon.uiColor
        iconImageView.backgroundColor = .clear
    }
    
    // MARK: - Override Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        lotNumberLabel.text = nil
        dateLabel.text = nil
        floorLabel.text = nil
        buildingLabel.text = nil
    }
    
    // MARK: - Internal Methods
    func configure(lotNumber: String, date: String, floor: String, building: String) {
        lotNumberLabel.text = lotNumber
        dateLabel.text = date
        floorLabel.text = floor
        buildingLabel.text = building
    }
}
