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
//        AuthManager.shared.deleteToken(tokenType: .refresh)
//        AuthManager.shared.deleteToken(tokenType: .access)
        interactor.loadStart(Model.Start.Request())
        interactor.loadLogin(Model.Login.Request())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8470588235, blue: 0.1058823529, alpha: 1)
        configureTitleLabel()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleLabel.pinRight(to: self.view.trailingAnchor, 38)
        titleLabel.text = "Parking\nit's never been\nso easy"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
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
