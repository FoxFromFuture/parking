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
        backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
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
        lotNumberLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        lotNumberLabel.font = .systemFont(ofSize: 28, weight: .semibold)
    }
    
    private func configureDateLabel() {
        self.addSubview(dateLabel)
        dateLabel.pinTop(to: self.lotNumberLabel.bottomAnchor, 10)
        dateLabel.pinLeft(to: self.leadingAnchor, 30)
        dateLabel.numberOfLines = 0
        dateLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        dateLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureFloorLabel() {
        self.addSubview(floorLabel)
        floorLabel.pinTop(to: self.dateLabel.bottomAnchor, 10)
        floorLabel.pinLeft(to: self.leadingAnchor, 30)
        floorLabel.numberOfLines = 0
        floorLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        floorLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureBuildingLabel() {
        self.addSubview(buildingLabel)
        buildingLabel.pinTop(to: self.floorLabel.bottomAnchor, 4)
        buildingLabel.pinLeft(to: self.leadingAnchor, 30)
        buildingLabel.pinBottom(to: self.bottomAnchor, 25)
        buildingLabel.numberOfLines = 0
        buildingLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        buildingLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureIconImageView() {
        self.addSubview(iconImageView)
        iconImageView.pinCenterY(to: self.centerYAnchor)
        iconImageView.pinRight(to: self.trailingAnchor, 30)
        iconImageView.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        iconImageView.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        iconImageView.backgroundColor = UIColor.clear
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
