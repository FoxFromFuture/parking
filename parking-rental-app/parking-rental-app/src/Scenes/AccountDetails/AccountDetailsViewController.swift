//
//  AccountDetailsViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

// MARK: - AccountDetailsViewController
final class AccountDetailsViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: AccountDetailsBusinessLogic
    private let router: AccountDetailsRoutingLogic
    private let tabBar = TabBar()
    private let nameDetailsCardButton = DetailsCardButton()
    private let emailDetailsCardButton = DetailsCardButton()
    private let deleteAccountButton = UIButton()
    private let deleteAccountAlert = UIAlertController()
    
    // MARK: - LifeCycle
    init(
        router: AccountDetailsRoutingLogic,
        interactor: AccountDetailsBusinessLogic
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
        interactor.loadUserDetails(AccountDetailsModel.UserDetails.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureTabBar()
        configureNameDetailsCardButton()
        configureEmailDetailsCardButton()
        configureDeleteAccountButton()
        configureDeleteAccountAlert()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.active.uiColor
        navigationItem.title = "accountDetails".localize()
    }
    
    private func configureTabBar() {
        view.addSubview(tabBar)
        tabBar.pinBottom(to: self.view.bottomAnchor)
        tabBar.pinLeft(to: self.view.leadingAnchor)
        tabBar.pinRight(to: self.view.trailingAnchor)
        tabBar.setHeight(92)
        tabBar.setMoreButtonAction { [weak self] in
            self?.interactor.loadMore(Model.More.Request())
        }
        tabBar.setHomeButtonAction { [weak self] in
            self?.interactor.loadHome(Model.Home.Request())
        }
    }
    
    private func configureNameDetailsCardButton() {
        self.view.addSubview(nameDetailsCardButton)
        nameDetailsCardButton.pinHorizontal(to: self.view, 17)
        nameDetailsCardButton.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 20)
        nameDetailsCardButton.setLeftIcon(icon: "person.fill")
        nameDetailsCardButton.hideRightIcon()
    }
    
    private func configureEmailDetailsCardButton() {
        self.view.addSubview(emailDetailsCardButton)
        emailDetailsCardButton.pinHorizontal(to: self.view, 17)
        emailDetailsCardButton.pinTop(to: self.nameDetailsCardButton.bottomAnchor)
        emailDetailsCardButton.setLeftIcon(icon: "envelope.fill")
        emailDetailsCardButton.hideRightIcon()
    }
    
    private func configureDeleteAccountButton() {
        self.view.addSubview(deleteAccountButton)
        deleteAccountButton.pinBottom(to: self.tabBar.topAnchor, 25)
        deleteAccountButton.setHeight(70)
        deleteAccountButton.pinHorizontal(to: self.view, 17)
        deleteAccountButton.backgroundColor = Colors.secondaryButton.uiColor
        deleteAccountButton.layer.cornerRadius = 20
        deleteAccountButton.setTitle("deleteAccount".localize(), for: .normal)
        deleteAccountButton.setTitleColor(Colors.danger.uiColor, for: .normal)
        deleteAccountButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonWasTapped), for: .touchDown)
    }
    
    private func configureDeleteAccountAlert() {
        deleteAccountAlert.message = "deleteAccountQuestion".localize()
        deleteAccountAlert.addAction(UIAlertAction(title: "deleteAccount".localize(), style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadLogin(Model.Login.Request())
        }))
        deleteAccountAlert.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadProfile(AccountDetailsModel.Profile.Request())
    }
    
    @objc
    private func deleteAccountButtonWasTapped() {
        self.navigationController?.present(deleteAccountAlert, animated: true)
    }
}

// MARK: - DisplayLogic
extension AccountDetailsViewController: AccountDetailsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayProfile(_ viewModel: Model.Profile.ViewModel) {
        self.router.routeToProfile()
    }
    
    func displayUserDetails(_ viewModel: Model.UserDetails.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.nameDetailsCardButton.setTitle(title: viewModel.name)
            self?.emailDetailsCardButton.setTitle(title: viewModel.email)
        }
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayLogin(_ viewModel: Model.Login.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToLogin()
        }
    }
}
