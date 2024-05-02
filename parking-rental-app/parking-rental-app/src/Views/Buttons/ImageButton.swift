//
//  ImageButton.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/27/24.
//

import UIKit

class ImageButton: UIView {
    
    public var pressAction: (() -> Void)?
    
    private let stackView = UIStackView()
    private let textLabel = UILabel()
    private let iconView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(
        _ text: String,
        _ color: UIColor,
        _ font: UIFont
    ) {
        textLabel.text = text
        textLabel.textColor = color
        textLabel.textAlignment = .center
        textLabel.font = font
    }
    
    func setIcon(_ image: UIImage, _ tintColor: UIColor, height: Double? = nil, width: Double? = nil) {
        iconView.image = image
        iconView.tintColor = tintColor
        iconView.backgroundColor = UIColor.clear
        if let height = height, let width = width {
            iconView.setHeight(height)
            iconView.setWidth(width)
        }
    }
    
    func configureUI() {
        self.configureStackView()
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.TabBarButtonWasPressed(_:))
        )
        addGestureRecognizer(tapRecognizer)
    }
    
    private func configureStackView() {
        addSubview(stackView)
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.pin(to: self)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(textLabel)
    }
    
    @objc
    private func TabBarButtonWasPressed(
        _ sender: UITapGestureRecognizer? = nil
    ) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.pressAction?()
    }
}
