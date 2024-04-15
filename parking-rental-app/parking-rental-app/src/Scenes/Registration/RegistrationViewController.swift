//
//  RegistrationViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

// MARK: - RegistrationViewController
final class RegistrationViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: RegistrationBusinessLogic
    private let router: RegistrationRoutingLogic
    private let registrationLabel = UILabel()
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerButton = UIButton()
    private let registrationFailureLabel = UILabel()
    private var nameTextFieldBottomBorder = UIView()
    private var emailTextFieldBottomBorder = UIView()
    private var passwordTextFieldBottomBorder = UIView()
    private var currentState: RegistrationState = .stable {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: RegistrationRoutingLogic,
        interactor: RegistrationBusinessLogic
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
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureRegistrationLabel()
        configureNameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureRegisterButton()
        configureRegistrationFailureLabel()
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
    
    private func configureRegistrationLabel() {
        self.view.addSubview(registrationLabel)
        registrationLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
        registrationLabel.pinLeft(to: self.view.leadingAnchor, 38)
        registrationLabel.pinRight(to: self.view.trailingAnchor, 38)
        registrationLabel.text = "registration".localize()
        registrationLabel.textAlignment = .left
        registrationLabel.textColor = Colors.mainText.uiColor
        registrationLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureNameTextField() {
        self.view.addSubview(nameTextField)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "name".localize(), attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor])
        nameTextField.font = .systemFont(ofSize: 24, weight: .regular)
        nameTextField.textColor = Colors.mainText.uiColor
        nameTextField.textAlignment = .left
        nameTextField.pinTop(to: self.registrationLabel.bottomAnchor, 80)
        nameTextField.pinLeft(to: self.view, 38)
        nameTextField.pinRight(to: self.view, 38)
        nameTextField.backgroundColor = .clear
        self.nameTextFieldBottomBorder = nameTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configureEmailTextField() {
        self.view.addSubview(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor])
        emailTextField.font = .systemFont(ofSize: 24, weight: .regular)
        emailTextField.textColor = Colors.mainText.uiColor
        emailTextField.textAlignment = .left
        emailTextField.pinTop(to: self.nameTextField.bottomAnchor, 50)
        emailTextField.pinLeft(to: self.view, 38)
        emailTextField.pinRight(to: self.view, 38)
        emailTextField.backgroundColor = .clear
        self.emailTextFieldBottomBorder = emailTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configurePasswordTextField() {
        self.view.addSubview(passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password".localize(), attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor])
        passwordTextField.font = .systemFont(ofSize: 24, weight: .regular)
        passwordTextField.textColor = Colors.mainText.uiColor
        passwordTextField.textAlignment = .left
        passwordTextField.pinTop(to: self.emailTextField.bottomAnchor, 50)
        passwordTextField.pinLeft(to: self.view, 38)
        passwordTextField.pinRight(to: self.view, 38)
        passwordTextField.backgroundColor = .clear
        self.passwordTextFieldBottomBorder = passwordTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configureRegisterButton() {
        self.view.addSubview(registerButton)
        registerButton.pinTop(to: self.passwordTextField.bottomAnchor, 70)
        registerButton.setHeight(70)
        registerButton.pinHorizontal(to: self.view, 38)
        registerButton.backgroundColor = Colors.accent.uiColor
        registerButton.layer.cornerRadius = 20
        registerButton.setTitle("register".localize(), for: .normal)
        registerButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        registerButton.addTarget(self, action: #selector(registerButtonWasTapped), for: .touchDown)
    }
    
    private func configureRegistrationFailureLabel() {
        registrationFailureLabel.text = "registrationFailure".localize()
        registrationFailureLabel.textColor = Colors.danger.uiColor
        registrationFailureLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadLogin(Model.Login.Request())
    }
    
    @objc
    private func registerButtonWasTapped() {
        /// TODO: Check if textFields contains characters
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            interactor.loadRegistrationCar(Model.RegistrationCar.Request(name: name, email: email, password: password))
        }
    }
    
    private func showStableState() {
        registrationFailureLabel.removeFromSuperview()
        nameTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
        emailTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
        passwordTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
    }
    
    private func showRegistrationFailure() {
        self.view.addSubview(registrationFailureLabel)
        registrationFailureLabel.pinTop(to: self.passwordTextField.bottomAnchor, 30)
        registrationFailureLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        nameTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
        emailTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
        passwordTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
    }
}

// MARK: - DisplayLogic
extension RegistrationViewController: RegistrationDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayRegistrationCar(_ viewModel: RegistrationModel.RegistrationCar.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToRegistrationCar()
        }
    }
    
    func displayLogin(_ viewModel: RegistrationModel.Login.ViewModel) {
        self.router.routeToLogin()
    }
    
    func displayRegistrationFailure(_ viewModel: RegistrationModel.RegistrationFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .registrationFailure
        }
    }
}

// MARK: - UpdateUIForState
extension RegistrationViewController {
    func updateUIForState(_ state: RegistrationState) {
        switch state {
        case .stable:
            showStableState()
        case .registrationFailure:
            showRegistrationFailure()
        }
    }
}
