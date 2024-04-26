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
    private let updateDetailsButton = UIButton()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingFailureLabel = UILabel()
    private let reloadButton = UIButton()
    private var currentState: AccountDetailsState = .loading {
        didSet {
            updateUIForState(currentState)
        }
    }
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentState == .error {
            loadingFailureLabel.removeFromSuperview()
            reloadButton.removeFromSuperview()
        }
        currentState = .loading
        interactor.loadUserDetails(AccountDetailsModel.UserDetails.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureTabBar()
        configureDeleteAccountButton()
        configureDeleteAccountAlert()
        configureUpdateDetailsButton()
        configureLoadingIndicator()
        configureLoadingFailureLabel()
        configureReloadButton()
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
    
    private func configureNameDetailsCardButton(name: String) {
        self.view.addSubview(nameDetailsCardButton)
        nameDetailsCardButton.pinHorizontal(to: self.view, 17)
        nameDetailsCardButton.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 20)
        nameDetailsCardButton.setLeftIcon(icon: "person.fill")
        nameDetailsCardButton.hideRightIcon()
        nameDetailsCardButton.setTitle(title: name)
    }
    
    private func configureEmailDetailsCardButton(email: String) {
        self.view.addSubview(emailDetailsCardButton)
        emailDetailsCardButton.pinHorizontal(to: self.view, 17)
        emailDetailsCardButton.pinTop(to: self.nameDetailsCardButton.bottomAnchor)
        emailDetailsCardButton.setLeftIcon(icon: "envelope.fill")
        emailDetailsCardButton.hideRightIcon()
        emailDetailsCardButton.setTitle(title: email)
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
    
    private func configureUpdateDetailsButton() {
        self.view.addSubview(updateDetailsButton)
        updateDetailsButton.pinBottom(to: self.deleteAccountButton.topAnchor, 20)
        updateDetailsButton.setHeight(70)
        updateDetailsButton.pinHorizontal(to: self.view, 17)
        updateDetailsButton.backgroundColor = Colors.secondaryButton.uiColor
        updateDetailsButton.layer.cornerRadius = 20
        updateDetailsButton.setTitle("updateAccountDetails".localize(), for: .normal)
        updateDetailsButton.setTitleColor(Colors.active.uiColor, for: .normal)
        updateDetailsButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        updateDetailsButton.addTarget(self, action: #selector(updateDetailsButtonWasTapped), for: .touchDown)
    }
    
    private func configureLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.pinCenter(to: self.view)
        loadingIndicator.color = Colors.secondaryText.uiColor
    }
    
    private func configureLoadingFailureLabel() {
        loadingFailureLabel.text = "connectionError".localize()
        loadingFailureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        loadingFailureLabel.textColor = Colors.mainText.uiColor
    }
    
    private func configureReloadButton() {
        reloadButton.setTitle("reload".localize(), for: .normal)
        reloadButton.setTitleColor(Colors.active.uiColor, for: .normal)
        reloadButton.setTitleColor(Colors.secondaryText.uiColor, for: .highlighted)
        reloadButton.backgroundColor = .clear
        reloadButton.addTarget(self, action: #selector(reloadButtonWasPressed), for: .touchUpInside)
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
    
    @objc
    private func updateDetailsButtonWasTapped() {
        self.interactor.loadUpdateAccount(AccountDetailsModel.UpdateAccount.Request())
    }
    
    @objc
    private func reloadButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        loadingFailureLabel.removeFromSuperview()
        reloadButton.removeFromSuperview()
        currentState = .loading
        interactor.loadUserDetails(AccountDetailsModel.UserDetails.Request())
    }
    
    private func showLoadingFailure() {
        view.addSubview(loadingFailureLabel)
        loadingFailureLabel.pinCenterX(to: self.view.centerXAnchor)
        loadingFailureLabel.pinTop(to: self.view, self.view.frame.height / 2.0 - 15)
        
        view.addSubview(reloadButton)
        reloadButton.pinTop(to: self.view, self.view.frame.height / 2.0 + 15)
        reloadButton.pinCenterX(to: self.view.centerXAnchor)
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
            self?.currentState = .loaded
            self?.configureNameDetailsCardButton(name: viewModel.name)
            self?.configureEmailDetailsCardButton(email: viewModel.email)
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
    
    func displayUpdateAccount(_ viewModel: Model.UpdateAccount.ViewModel) {
        self.router.routeToUpdateAccount()
    }
    
    func displayUpdateAccountFailure(_ viewModel: Model.UpdateAccountFailure.ViewModel) {
        DispatchQueue.main.async {
            self.currentState = .error
        }
    }
}

// MARK: - UpdateUIForState
extension AccountDetailsViewController {
    func updateUIForState(_ state: AccountDetailsState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .error:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        }
    }
}
