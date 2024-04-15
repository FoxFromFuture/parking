//
//  LoginViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

// MARK: - LoginViewController
final class LoginViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: LoginBusinessLogic
    private let router: LoginRoutingLogic
    private let loginLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registrationButton = UIButton()
    private let enterButton = UIButton()
    private let loginFailureLabel = UILabel()
    private var emailTextFieldBottomBorder = UIView()
    private var passwordTextFieldBottomBorder = UIView()
    private var currentState: LoginState = .stable {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: LoginRoutingLogic,
        interactor: LoginBusinessLogic
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
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if self.currentState == .loginFailure {
            self.currentState = .stable
        }
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureLoginLabel()
        configureEmailTextField()
        configurePasswordTextField()
        configureEnterButton()
        configureRegistrationButton()
        configureLoginFailureLabel()
    }
    
    private func configureLoginLabel() {
        self.view.addSubview(loginLabel)
        loginLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        loginLabel.pinLeft(to: self.view.leadingAnchor, 38)
        loginLabel.pinRight(to: self.view.trailingAnchor, 38)
        loginLabel.text = "login".localize()
        loginLabel.textAlignment = .left
        loginLabel.textColor = Colors.mainText.uiColor
        loginLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureEmailTextField() {
        self.view.addSubview(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor]
        )
        emailTextField.font = .systemFont(ofSize: 24, weight: .regular)
        emailTextField.textColor = Colors.mainText.uiColor
        emailTextField.textAlignment = .left
        emailTextField.pinTop(to: self.loginLabel.bottomAnchor, 80)
        emailTextField.pinLeft(to: self.view.leadingAnchor, 38)
        emailTextField.pinRight(to: self.view.trailingAnchor, 38)
        emailTextField.backgroundColor = .clear
        self.emailTextFieldBottomBorder = emailTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configurePasswordTextField() {
        self.view.addSubview(passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "password".localize(),
            attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor]
        )
        passwordTextField.font = .systemFont(ofSize: 24, weight: .regular)
        passwordTextField.textColor = Colors.mainText.uiColor
        passwordTextField.textAlignment = .left
        passwordTextField.pinTop(to: self.emailTextField.bottomAnchor, 50)
        passwordTextField.pinLeft(to: self.view.leadingAnchor, 38)
        passwordTextField.pinRight(to: self.view.trailingAnchor, 38)
        passwordTextField.backgroundColor = .clear
        self.passwordTextFieldBottomBorder = passwordTextField.addBottomBorder(color: Colors.secondaryText.uiColor, thickness: 2)
    }
    
    private func configureRegistrationButton() {
        self.view.addSubview(registrationButton)
        registrationButton.pinTop(to: self.enterButton.bottomAnchor, 15)
        registrationButton.pinRight(to: self.view.trailingAnchor, 38)
        registrationButton.setTitle("registration".localize(), for: .normal)
        registrationButton.setTitleColor(Colors.active.uiColor, for: .normal)
        registrationButton.setTitleColor(Colors.secondaryText.uiColor, for: .highlighted)
        registrationButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        registrationButton.addTarget(self, action: #selector(registrationButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureEnterButton() {
        self.view.addSubview(enterButton)
        enterButton.pinTop(to: self.passwordTextField.bottomAnchor, 70)
        enterButton.setHeight(70)
        enterButton.pinHorizontal(to: self.view, 38)
        enterButton.backgroundColor = Colors.accent.uiColor
        enterButton.layer.cornerRadius = 20
        enterButton.setTitle("enter".localize(), for: .normal)
        enterButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        enterButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        enterButton.addTarget(self, action: #selector(enterButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureLoginFailureLabel() {
        loginFailureLabel.text = "loginFailure".localize()
        loginFailureLabel.textColor = Colors.danger.uiColor
        loginFailureLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Actions
    @objc
    private func enterButtonWasTapped() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            interactor.loadHome(Model.Home.Request(email: email, password: password))
        }
    }
    
    @objc
    private func registrationButtonWasTapped() {
        interactor.loadRegistration(Model.Registration.Request())
    }
    
    private func showStableState() {
        loginFailureLabel.removeFromSuperview()
        emailTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
        passwordTextFieldBottomBorder.backgroundColor = Colors.secondaryText.uiColor
    }
    
    private func showLoginFailure() {
        self.view.addSubview(loginFailureLabel)
        loginFailureLabel.pinTop(to: self.passwordTextField.bottomAnchor, 30)
        loginFailureLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        emailTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
        passwordTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
    }
}

// MARK: - DisplayLogic
extension LoginViewController: LoginDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToHome()
        }
    }
    
    func displayRegistration(_ viewModel: Model.Registration.ViewModel) {
        router.routeToRegistration()
    }
    
    func displayLoginFailure(_ viewModel: LoginModel.LoginFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loginFailure
        }
    }
}

// MARK: - UpdateUIForState
extension LoginViewController {
    func updateUIForState(_ state: LoginState) {
        switch state {
        case .stable:
            showStableState()
        case .loginFailure:
            showLoginFailure()
        }
    }
}
