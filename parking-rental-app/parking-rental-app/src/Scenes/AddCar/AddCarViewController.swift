//
//  AddCarViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit

// MARK: - AddCarViewController
final class AddCarViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: AddCarBusinessLogic
    private let router: AddCarRoutingLogic
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let carModelTextField = UITextField()
    private let carRegistryNumberTextField = UITextField()
    private var modelTextFieldBottomBorder = UIView()
    private var regNumTextFieldBottomBorder = UIView()
    private let saveButton = UIButton()
    private let carSetupFailureLabel = UILabel()
    private var currentState: AddCarState = .stable {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: AddCarRoutingLogic,
        interactor: AddCarBusinessLogic
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
        configureTitleLabel()
        configureSubTitleLabel()
        configureCarModelTextField()
        configureCarRegistryNumberTextFieldTextField()
        configureContinueButton()
        configureCarSetupFailureLabel()
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
        titleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleLabel.pinRight(to: self.view.trailingAnchor, 38)
        titleLabel.text = "addCarTitle".localize()
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
        subTitleLabel.text = "addCarSubtitle".localize()
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
        carRegistryNumberTextField.pinTop(to: self.carModelTextField.bottomAnchor, 60)
        carRegistryNumberTextField.pinLeft(to: self.view, 38)
        carRegistryNumberTextField.pinRight(to: self.view, 38)
        carRegistryNumberTextField.backgroundColor = .clear
        self.regNumTextFieldBottomBorder = carRegistryNumberTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configureContinueButton() {
        self.view.addSubview(saveButton)
        saveButton.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 70)
        saveButton.setHeight(70)
        saveButton.pinHorizontal(to: self.view, 38)
        saveButton.backgroundColor = Colors.accent.uiColor
        saveButton.layer.cornerRadius = 20
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        saveButton.addTarget(self, action: #selector(saveButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureCarSetupFailureLabel() {
        carSetupFailureLabel.text = "addCarSetupFailure".localize()
        carSetupFailureLabel.textColor = Colors.danger.uiColor
        carSetupFailureLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadAccountCars(Model.AccountCars.Request())
    }
    
    @objc
    private func saveButtonWasTapped() {
        if let carRegistryNumber = carRegistryNumberTextField.text, let carModel = carModelTextField.text {
            interactor.loadAddCarRequest(AddCarModel.AddCarRequest.Request(model: carModel, registryNumber: carRegistryNumber))
        }
    }
    
    private func showStableState() {
        carSetupFailureLabel.removeFromSuperview()
        regNumTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
        modelTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
    }
    
    private func showCarSetupFailure() {
        self.view.addSubview(carSetupFailureLabel)
        carSetupFailureLabel.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 30)
        carSetupFailureLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        regNumTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
        modelTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
    }
}

// MARK: - DisplayLogic
extension AddCarViewController: AddCarDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayAccountCars(_ viewModel: Model.AccountCars.ViewModel) {
        self.router.routeToAccountCars()
    }
    
    func displayAddCarRequest(_ viewModel: Model.AddCarRequest.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .stable
            self?.router.routeToAccountCars()
        }
    }
    
    func displayAddCarFailure(_ viewModel: Model.AddCarFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .carSetupFailure
        }
    }
}

// MARK: - UpdateUIForState
extension AddCarViewController {
    func updateUIForState(_ state: AddCarState) {
        switch state {
        case .stable:
            showStableState()
        case .carSetupFailure:
            showCarSetupFailure()
        }
    }
}
