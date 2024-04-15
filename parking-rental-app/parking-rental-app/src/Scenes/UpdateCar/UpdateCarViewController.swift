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
    private let carUpdateFailureLabel = UILabel()
    private var regNumTextFieldBottomBorder = UIView()
    private var currentState: UpdateCarState = .stable {
        didSet {
            updateUIForState(currentState)
        }
    }
    
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
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureTabBar()
        configureTitleLabel()
        configureSubTitleLabel()
        configureCarRegistryNumberTextFieldTextField()
        configureSaveButton()
        configureCarUpdateFailureLabel()
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
        titleLabel.text = "updateCarTitle".localize()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureSubTitleLabel() {
        self.view.addSubview(subTitleLabel)
        subTitleLabel.pinTop(to: self.titleLabel.bottomAnchor, 15)
        subTitleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        subTitleLabel.pinRight(to: self.view.trailingAnchor, 38)
        subTitleLabel.text = "updateCarSubtitle".localize()
        subTitleLabel.textAlignment = .left
        subTitleLabel.textColor = Colors.secondaryText.uiColor
        subTitleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureCarRegistryNumberTextFieldTextField() {
        self.view.addSubview(carRegistryNumberTextField)
        carRegistryNumberTextField.attributedPlaceholder = NSAttributedString(string: "X000XX000", attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor])
        carRegistryNumberTextField.font = .systemFont(ofSize: 24, weight: .regular)
        carRegistryNumberTextField.textColor = Colors.mainText.uiColor
        carRegistryNumberTextField.textAlignment = .left
        carRegistryNumberTextField.pinTop(to: self.subTitleLabel.bottomAnchor, 60)
        carRegistryNumberTextField.pinLeft(to: self.view, 38)
        carRegistryNumberTextField.pinRight(to: self.view, 38)
        carRegistryNumberTextField.backgroundColor = .clear
        self.regNumTextFieldBottomBorder = carRegistryNumberTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configureSaveButton() {
        self.view.addSubview(saveButton)
        saveButton.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 70)
        saveButton.setHeight(70)
        saveButton.pinHorizontal(to: self.view, 38)
        saveButton.backgroundColor = Colors.accent.uiColor
        saveButton.layer.cornerRadius = 20
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        saveButton.addTarget(self, action: #selector(saveButtonWasTapped), for: .touchDown)
    }
    
    private func configureCarUpdateFailureLabel() {
        carUpdateFailureLabel.text = "updateCarFailure".localize()
        carUpdateFailureLabel.textColor = Colors.danger.uiColor
        carUpdateFailureLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadProfile(Model.Profile.Request())
    }
    
    @objc
    private func saveButtonWasTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if let newRegistryNumber = carRegistryNumberTextField.text {
            self.interactor.loadUpdateCarRequest(Model.UpdateCarRequest.Request(newRegistryNumber: newRegistryNumber))
        }
    }
    
    private func showStableState() {
        carUpdateFailureLabel.removeFromSuperview()
        regNumTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
    }
    
    private func showCarUpdateFailure() {
        self.view.addSubview(carUpdateFailureLabel)
        carUpdateFailureLabel.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 30)
        carUpdateFailureLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        regNumTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
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
    
    func displayUpdateCarFailure(_ viewModel: Model.CarUpdateFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .carUpdateFailure
        }
    }
}

// MARK: - UpdateUIForState
extension UpdateCarViewController {
    func updateUIForState(_ state: UpdateCarState) {
        switch state {
        case .stable:
            showStableState()
        case .carUpdateFailure:
            showCarUpdateFailure()
        }
    }
}
