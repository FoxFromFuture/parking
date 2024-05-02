//
//  OnboardingViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/1/24.
//

import UIKit

// MARK: - OnboardingViewController
final class OnboardingViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: OnboardingBusinessLogic
    private let router: OnboardingRoutingLogic
    private let letsGoButton = UIButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - LifeCycle
    init(
        router: OnboardingRoutingLogic,
        interactor: OnboardingBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureLetsGoButton()
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    private func configureLetsGoButton() {
        self.view.addSubview(letsGoButton)
        letsGoButton.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor, 40)
        letsGoButton.setHeight(70)
        letsGoButton.pinHorizontal(to: self.view, 17)
        letsGoButton.backgroundColor = Colors.accent.uiColor
        letsGoButton.layer.cornerRadius = 20
        letsGoButton.setTitle("letsGo".localize(), for: .normal)
        letsGoButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        letsGoButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        letsGoButton.addTarget(self, action: #selector(letsGoButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 17)
        titleLabel.text = "welcome".localize()
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureDescriptionLabel() {
        self.view.addSubview(descriptionLabel)
        descriptionLabel.pinCenterY(to: self.view.centerYAnchor)
        descriptionLabel.pinLeft(to: self.view.leadingAnchor, 17)
        descriptionLabel.pinRight(to: self.view.trailingAnchor, 17)
        descriptionLabel.text = "onboardingDescription".localize()
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Colors.mainText.uiColor
        descriptionLabel.font = .systemFont(ofSize: 22, weight: .regular)
    }
    
    // MARK: - Actions
    @objc
    private func letsGoButtonWasTapped() {
        interactor.loadHome(Model.Home.Request())
    }
}

// MARK: - DisplayLogic
extension OnboardingViewController: OnboardingDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
}
