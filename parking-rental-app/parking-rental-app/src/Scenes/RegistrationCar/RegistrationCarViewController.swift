//
//  RegistrationCarViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

// MARK: - RegistrationCarViewController
final class RegistrationCarViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: RegistrationCarBusinessLogic
    private let router: RegistrationCarRoutingLogic
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let carRegistryNumberTextField = UITextField()
    private let continueButton = UIButton()
    private let carSetupFailureLabel = UILabel()
    private var regNumTextFieldBottomBorder = UIView()
    private var currentState: RegistrationCarState = .stable {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: RegistrationCarRoutingLogic,
        interactor: RegistrationCarBusinessLogic
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureTitleLabel()
        configureSubTitleLabel()
        configureCarRegistryNumberTextFieldTextField()
        configureContinueButton()
        configureCarSetupFailureLabel()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleLabel.pinRight(to: self.view.trailingAnchor, 38)
        titleLabel.text = "registrationCarTitle".localize()
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
        subTitleLabel.text = "registrationCarSubtitle".localize()
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
    
    private func configureContinueButton() {
        self.view.addSubview(continueButton)
        continueButton.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 70)
        continueButton.setHeight(70)
        continueButton.pinHorizontal(to: self.view, 38)
        continueButton.backgroundColor = Colors.accent.uiColor
        continueButton.layer.cornerRadius = 20
        continueButton.setTitle("continue".localize(), for: .normal)
        continueButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        continueButton.addTarget(self, action: #selector(continueButtonWasTapped), for: .touchDown)
    }
    
    private func configureCarSetupFailureLabel() {
        carSetupFailureLabel.text = "registrationCarSetupFailure".localize()
        carSetupFailureLabel.textColor = Colors.danger.uiColor
        carSetupFailureLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Actions
    @objc
    private func continueButtonWasTapped() {
        if let carRegistryNumber = carRegistryNumberTextField.text {
            interactor.loadHome(Model.Home.Request(carRegistryNumber: carRegistryNumber))
        }
    }
    
    private func showStableState() {
        carSetupFailureLabel.removeFromSuperview()
        regNumTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
    }
    
    private func showCarSetupFailure() {
        self.view.addSubview(carSetupFailureLabel)
        carSetupFailureLabel.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 30)
        carSetupFailureLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        regNumTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
    }
}

// MARK: - DisplayLogic
extension RegistrationCarViewController: RegistrationCarDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayHome(_ viewModel: RegistrationCarModel.Home.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToHome()
        }
    }
    
    func displayCarSetupFailure(_ viewModel: RegistrationCarModel.CarSetupFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .carSetupFailure
        }
    }
}

// MARK: - UpdateUIForState
extension RegistrationCarViewController {
    func updateUIForState(_ state: RegistrationCarState) {
        switch state {
        case .stable:
            showStableState()
        case .carSetupFailure:
            showCarSetupFailure()
        }
    }
}
