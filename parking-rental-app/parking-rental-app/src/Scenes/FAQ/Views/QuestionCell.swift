//
//  QuestionCell.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/26/24.
//

import UIKit

// MARK: - QuestionCell
final class QuestionCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private let mainContainer = UIView()
    private let topContainer = UIView()
    private let bottomContainer = UIView()
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private let leftIconImageView = UIImageView()
    private let rightIconImageView = UIImageView()
    private var expandedConstraint: NSLayoutConstraint?
    private var collapsedConstraint: NSLayoutConstraint?
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
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
        self.backgroundColor = Colors.FAQCell.uiColor
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        configureMainContainer()
        configureTopContainer()
        configureBottomContainer()
        configureQuestionLabel()
        configureLeftIconImageView()
        configureRightIconImageView()
        configureAnswerLabel()
        self.updateAppearance()
    }
    
    private func configureMainContainer() {
        self.addSubview(mainContainer)
        mainContainer.pin(to: self)
        mainContainer.backgroundColor = .clear
    }
    
    private func configureTopContainer() {
        mainContainer.addSubview(topContainer)
        topContainer.pinTop(to: self.topAnchor)
        topContainer.pinLeft(to: self.leadingAnchor)
        topContainer.pinRight(to: self.trailingAnchor)
        self.collapsedConstraint = topContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.collapsedConstraint?.priority = .defaultLow
        topContainer.backgroundColor = .clear
    }
    
    private func configureBottomContainer() {
        mainContainer.addSubview(bottomContainer)
        bottomContainer.pinTop(to: self.topContainer.bottomAnchor)
        bottomContainer.pinLeft(to: self.leadingAnchor)
        bottomContainer.pinRight(to: self.trailingAnchor)
        self.expandedConstraint = bottomContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.expandedConstraint?.priority = .defaultLow
        bottomContainer.backgroundColor = .clear
    }
    
    private func configureQuestionLabel() {
        self.topContainer.addSubview(questionLabel)
        questionLabel.pinTop(to: self.topContainer.topAnchor, 15)
        questionLabel.pinBottom(to: self.topContainer.bottomAnchor, 15)
        questionLabel.pinLeft(to: self.topContainer.leadingAnchor, 65)
        questionLabel.pinRight(to: self.topContainer.trailingAnchor, 45)
        questionLabel.numberOfLines = 0
        questionLabel.textColor = Colors.mainText.uiColor
        questionLabel.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private func configureLeftIconImageView() {
        self.topContainer.addSubview(leftIconImageView)
        leftIconImageView.pinCenterY(to: self.topContainer.centerYAnchor)
        leftIconImageView.pinLeft(to: self.topContainer.leadingAnchor, 20)
        leftIconImageView.image = UIImage(systemName: "person.fill.questionmark", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        leftIconImageView.tintColor = Colors.active.uiColor
        leftIconImageView.backgroundColor = .clear
    }
    
    private func configureRightIconImageView() {
        self.topContainer.addSubview(rightIconImageView)
        rightIconImageView.pinCenterY(to: self.topContainer.centerYAnchor)
        rightIconImageView.pinRight(to: self.topContainer.trailingAnchor, 30)
        rightIconImageView.image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)) ?? UIImage()
        rightIconImageView.tintColor = Colors.icon.uiColor
        rightIconImageView.backgroundColor = .clear
    }
    
    private func configureAnswerLabel() {
        self.bottomContainer.addSubview(answerLabel)
        answerLabel.pinTop(to: self.bottomContainer.topAnchor)
        answerLabel.pinBottom(to: self.bottomContainer.bottomAnchor, 15)
        answerLabel.pinLeft(to: self.bottomContainer.leadingAnchor, 65)
        answerLabel.pinRight(to: self.bottomContainer.trailingAnchor, 45)
        answerLabel.numberOfLines = 0
        answerLabel.textColor = Colors.mainText.uiColor
        answerLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    // MARK: - Override Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        questionLabel.text = nil
        answerLabel.text = nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        self.topContainer.point(inside: point, with: event)
    }
    
    // MARK: - Internal Methods
    func configure(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
    }
    
    func updateAppearance() {
        self.collapsedConstraint?.isActive = !isSelected
        self.expandedConstraint?.isActive = isSelected
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self.rightIconImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
}


