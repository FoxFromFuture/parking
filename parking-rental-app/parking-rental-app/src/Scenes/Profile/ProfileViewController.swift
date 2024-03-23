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
    private let tabBar = TabBar()
    private let titleLabel = UILabel()
    private let logOutButton = UIButton()
    private let carSingleCardButton = SingleCardButton()
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
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureNavigationBar()
        configureTabBar()
        configureTitleLabel()
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
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
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
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 17)
        titleLabel.setHeight(45)
        titleLabel.text = "Profile"
        titleLabel.textAlignment = .left
        titleLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureCarSingleCardButton() {
        self.view.addSubview(carSingleCardButton)
        carSingleCardButton.pinTop(to: self.titleLabel.bottomAnchor, 30)
        carSingleCardButton.pinHorizontal(to: self.view, 17)
        carSingleCardButton.configure(title: "Car", subtitle: "Change car registry number")
        carSingleCardButton.setAction { [weak self] in
            self?.interactor.loadUpdateCar(Model.UpdateCar.Request())
        }
    }
    
    private func configureLogOutButton() {
        self.view.addSubview(logOutButton)
        logOutButton.pinBottom(to: self.tabBar.topAnchor, 25)
        logOutButton.setHeight(70)
        logOutButton.pinHorizontal(to: self.view, 17)
        logOutButton.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        logOutButton.layer.cornerRadius = 20
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        logOutButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        logOutButton.addTarget(self, action: #selector(logOutButtonWasTapped), for: .touchDown)
    }
    
    private func configureLogOutAlert() {
        logOutAlert.message = "Are you sure you want to log out?"
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadLogin(Model.Login.Request())
        }))
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    // MARK: - Actions
    @objc
    public func goBack() {
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
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayUpdateCar(_ viewModel: Model.UpdateCar.ViewModel) {
        self.router.routeToUpdateCar()
    }
    
    func displayLogin(_ viewModel: Model.Login.ViewModel) {
        self.router.routeToLogin()
    }
}
