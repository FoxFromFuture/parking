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
    private let carID: String
    private let tabBar = TabBar()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let carModelTextField = UITextField()
    private let carRegistryNumberTextField = UITextField()
    private let saveButton = UIButton()
    private let carUpdateFailureLabel = UILabel()
    private let carUpdateSuccessLabel = UILabel()
    private var modelTextFieldBottomBorder = UIView()
    private var regNumTextFieldBottomBorder = UIView()
    private var currentState: UpdateCarState = .stable {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: UpdateCarRoutingLogic,
        interactor: UpdateCarBusinessLogic,
        carID: String
    ) {
        self.router = router
        self.interactor = interactor
        self.carID = carID
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentState = .stable
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
        configureCarModelTextField()
        configureCarRegistryNumberTextFieldTextField()
        configureSaveButton()
        configureCarUpdateFailureLabel()
        configureCarUpdateSuccessLabel()
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
    
    private func configureCarModelTextField() {
        self.view.addSubview(carModelTextField)
        carModelTextField.attributedPlaceholder = NSAttributedString(string: "model".localize(), attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor])
        carModelTextField.font = .systemFont(ofSize: 24, weight: .regular)
        carModelTextField.textColor = Colors.mainText.uiColor
        carModelTextField.textAlignment = .left
        carModelTextField.pinTop(to: self.subTitleLabel.bottomAnchor, 60)
        carModelTextField.pinLeft(to: self.view, 38)
        carModelTextField.pinRight(to: self.view, 38)
        carModelTextField.backgroundColor = .clear
        self.modelTextFieldBottomBorder = carModelTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configureCarRegistryNumberTextFieldTextField() {
        self.view.addSubview(carRegistryNumberTextField)
        carRegistryNumberTextField.attributedPlaceholder = NSAttributedString(string: "X000XX000", attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor])
        carRegistryNumberTextField.font = .systemFont(ofSize: 24, weight: .regular)
        carRegistryNumberTextField.textColor = Colors.mainText.uiColor
        carRegistryNumberTextField.textAlignment = .left
        carRegistryNumberTextField.pinTop(to: self.carModelTextField.bottomAnchor, 50)
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
    private func  configureCarUpdateSuccessLabel() {
        carUpdateSuccessLabel.text = "updateCarSuccess".localize()
        carUpdateSuccessLabel.textColor = Colors.success.uiColor
        carUpdateSuccessLabel.font = .systemFont(ofSize: 16, weight: .medium)
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
        if let newRegistryNumber = carRegistryNumberTextField.text, let newModel = carModelTextField.text {
            self.interactor.loadUpdateCarRequest(Model.UpdateCarRequest.Request(carID: self.carID, newModel: newModel, newRegistryNumber: newRegistryNumber))
        }
    }
    
    private func showCarUpdateFailure() {
        self.view.addSubview(carUpdateFailureLabel)
        carUpdateFailureLabel.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 30)
        carUpdateFailureLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        regNumTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
        modelTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
    }
    
    private func showCarUpdateSuccess() {
        self.view.addSubview(carUpdateSuccessLabel)
        carUpdateSuccessLabel.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 30)
        carUpdateSuccessLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        regNumTextFieldBottomBorder.backgroundColor = Colors.success.uiColor
        modelTextFieldBottomBorder.backgroundColor = Colors.success.uiColor
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
            if self?.currentState == .carUpdateFailure {
                self?.carUpdateFailureLabel.removeFromSuperview()
            }
            self?.currentState = .carUpdateSuccess
        }
    }
    
    func displayUpdateCarFailure(_ viewModel: Model.CarUpdateFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            if self?.currentState == .carUpdateSuccess {
                self?.carUpdateSuccessLabel.removeFromSuperview()
            }
            self?.currentState = .carUpdateFailure
        }
    }
}

// MARK: - UpdateUIForState
extension UpdateCarViewController {
    func updateUIForState(_ state: UpdateCarState) {
        switch state {
        case .stable:
            break
        case .carUpdateFailure:
            showCarUpdateFailure()
        case .carUpdateSuccess:
            showCarUpdateSuccess()
        }
    }
}
