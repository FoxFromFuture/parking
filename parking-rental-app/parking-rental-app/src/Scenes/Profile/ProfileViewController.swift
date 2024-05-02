//
//  ProfileViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: ProfileBusinessLogic
    private let router: ProfileRoutingLogic
    private let titleLabel = UILabel()
    private let logOutButton = UIButton()
    private let carSingleCardButton = SingleCardButton()
    private let accountSingleCardButton = SingleCardButton()
    private let logOutAlert = UIAlertController()
    
    // MARK: - LifeCycle
    init(
        router: ProfileRoutingLogic,
        interactor: ProfileBusinessLogic
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
        self.navigationController?.isNavigationBarHidden = false
        interactor.loadStart(Model.Start.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureTitleLabel()
        configureAccountSingleCardButton()
        configureCarSingleCardButton()
        configureLogOutButton()
        configureLogOutAlert()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.active.uiColor
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 17)
        titleLabel.setHeight(45)
        titleLabel.text = "profile".localize()
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureAccountSingleCardButton() {
        self.view.addSubview(accountSingleCardButton)
        accountSingleCardButton.pinTop(to: self.titleLabel.bottomAnchor, 30)
        accountSingleCardButton.pinHorizontal(to: self.view, 17)
        accountSingleCardButton.configure(title: "account".localize(), subtitle: "accountDetails".localize())
        accountSingleCardButton.setAction { [weak self] in
            self?.interactor.loadAccountDetails(ProfileModel.AccountDetails.Request())
        }
    }
    
    private func configureCarSingleCardButton() {
        self.view.addSubview(carSingleCardButton)
        carSingleCardButton.pinTop(to: self.accountSingleCardButton.bottomAnchor, 25)
        carSingleCardButton.pinHorizontal(to: self.view, 17)
        carSingleCardButton.configure(title: "cars".localize(), subtitle: "yourCarDetails".localize())
        carSingleCardButton.setAction { [weak self] in
            self?.interactor.loadAccountCars(Model.AccountCars.Request())
        }
    }
    
    private func configureLogOutButton() {
        self.view.addSubview(logOutButton)
        logOutButton.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor, 25)
        logOutButton.setHeight(70)
        logOutButton.pinHorizontal(to: self.view, 17)
        logOutButton.backgroundColor = Colors.secondaryButton.uiColor
        logOutButton.layer.cornerRadius = 20
        logOutButton.setTitle("logOut".localize(), for: .normal)
        logOutButton.setTitleColor(Colors.danger.uiColor, for: .normal)
        logOutButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        logOutButton.addTarget(self, action: #selector(logOutButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureLogOutAlert() {
        logOutAlert.message = "logOutQuestion".localize()
        logOutAlert.addAction(UIAlertAction(title: "logOut".localize(), style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadLogin(Model.Login.Request())
        }))
        logOutAlert.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadHome(Model.Home.Request())
    }
    
    @objc
    private func logOutButtonWasTapped() {
        self.navigationController?.present(logOutAlert, animated: true)
    }
}

// MARK: - DisplayLogic
extension ProfileViewController: ProfileDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }

    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayAccountCars(_ viewModel: Model.AccountCars.ViewModel) {
        self.router.routeToAccountCars()
    }
    
    func displayLogin(_ viewModel: Model.Login.ViewModel) {
        self.router.routeToLogin()
    }
    
    func displayAccountDetails(_ viewModel: Model.AccountDetails.ViewModel) {
        self.router.routeToAccountDetails()
    }
}
