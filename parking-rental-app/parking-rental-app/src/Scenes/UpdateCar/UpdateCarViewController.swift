//
//  UpdateCarViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

// MARK: - UpdateCarViewController
final class UpdateCarViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: UpdateCarBusinessLogic
    private let router: UpdateCarRoutingLogic
    private let tabBar = TabBar()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let carRegistryNumberTextField = UITextField()
    private let saveButton = UIButton()
    
    // MARK: - LifeCycle
    init(
        router: UpdateCarRoutingLogic,
        interactor: UpdateCarBusinessLogic
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
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureNavigationBar()
        configureTabBar()
        configureTitleLabel()
        configureSubTitleLabel()
        configureCarRegistryNumberTextFieldTextField()
        configureSaveButton()
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
        titleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleLabel.pinRight(to: self.view.trailingAnchor, 38)
        titleLabel.text = "Set new car\nregistry number"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureSubTitleLabel() {
        self.view.addSubview(subTitleLabel)
        subTitleLabel.pinTop(to: self.titleLabel.bottomAnchor, 20)
        subTitleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        subTitleLabel.pinRight(to: self.view.trailingAnchor, 38)
        subTitleLabel.text = "To update your car details"
        subTitleLabel.textAlignment = .left
        subTitleLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        subTitleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureCarRegistryNumberTextFieldTextField() {
        self.view.addSubview(carRegistryNumberTextField)
        carRegistryNumberTextField.attributedPlaceholder = NSAttributedString(string: "X000XX000", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)])
        carRegistryNumberTextField.font = .systemFont(ofSize: 24, weight: .regular)
        carRegistryNumberTextField.textColor = .black
        carRegistryNumberTextField.textAlignment = .left
        carRegistryNumberTextField.pinTop(to: self.subTitleLabel.bottomAnchor, 60)
        carRegistryNumberTextField.pinLeft(to: self.view, 38)
        carRegistryNumberTextField.pinRight(to: self.view, 38)
        carRegistryNumberTextField.backgroundColor = .white
        carRegistryNumberTextField.borderStyle = .line
    }
    
    private func configureSaveButton() {
        self.view.addSubview(saveButton)
        saveButton.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 40)
        saveButton.setHeight(70)
        saveButton.pinHorizontal(to: self.view, 38)
        saveButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8470588235, blue: 0.1058823529, alpha: 1)
        saveButton.layer.cornerRadius = 20
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(#colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1), for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        saveButton.addTarget(self, action: #selector(saveButtonWasTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    @objc
    public func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadProfile(Model.Profile.Request())
    }
    
    @objc
    public func saveButtonWasTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if let newRegistryNumber = carRegistryNumberTextField.text {
            self.interactor.loadUpdateCarRequest(Model.UpdateCarRequest.Request(newRegistryNumber: newRegistryNumber))
        }
    }
}

// MARK: - DisplayLogic
extension UpdateCarViewController: UpdateCarDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayProfile(_ viewModel: Model.Profile.ViewModel) {
        self.router.routeToProfile()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayUpdateCarRequest(_ viewModel: Model.UpdateCarRequest.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToProfile()
        }
    }
}
