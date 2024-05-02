//
//  SplashViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import UIKit

// MARK: - SplashViewController
final class SplashViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: SplashBusinessLogic
    private let router: SplashRoutingLogic
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconImageView = UIImageView()
    
    // MARK: - LifeCycle
    init(
        router: SplashRoutingLogic,
        interactor: SplashBusinessLogic
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
        self.navigationController?.isNavigationBarHidden = true
        interactor.loadStart(Model.Start.Request())
        interactor.loadLogin(Model.Login.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.accent.uiColor
        configureTitleLabel()
        configureSubtitleLabel()
        configureIconImageView()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 177)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleLabel.text = "Parking"
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.mainText.uiColor.light
        titleLabel.font = .systemFont(ofSize: 64, weight: .bold)
    }
    
    private func configureSubtitleLabel() {
        self.view.addSubview(subtitleLabel)
        subtitleLabel.pinTop(to: self.titleLabel.bottomAnchor, 10)
        subtitleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        subtitleLabel.text = "launchSubtitle".localize()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = Colors.mainText.uiColor.light
        subtitleLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureIconImageView() {
        self.view.addSubview(iconImageView)
        iconImageView.pinLeft(to: self.titleLabel.trailingAnchor, 10)
        iconImageView.pinCenterY(to: self.titleLabel.centerYAnchor)
        iconImageView.setHeight(80)
        iconImageView.setWidth(80)
        iconImageView.tintColor = Colors.mainText.uiColor.light
        iconImageView.image = UIImage(systemName: "parkingsign.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
}

// MARK: - DisplayLogic
extension SplashViewController: SplashDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayLogin(_ viewModel: Model.Login.ViewModel) {
        router.routeToLogin()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        router.routeToHome()
    }
}
