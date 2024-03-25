//
//  MapView.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/24/24.
//

import UIKit

class MapView: UIView {
    // MARK: - LifeCycle
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureUI() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.parkingSpotButtonWasPressed(_:))
        )
        addGestureRecognizer(tapRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Actions
    @objc
    private func parkingSpotButtonWasPressed(_ sender: UITapGestureRecognizer? = nil) {
        // TODO: - Show parking spot reservation subview
    }
}
