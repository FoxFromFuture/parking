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
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureLoginLabel()
        configureEmailTextField()
        configurePasswordTextField()
        configureRegistrationButton()
        configureEnterButton()
    }
    
    private func configureLoginLabel() {
        self.view.addSubview(loginLabel)
        loginLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 35)
        loginLabel.pinLeft(to: self.view.leadingAnchor, 38)
        loginLabel.pinRight(to: self.view.trailingAnchor, 38)
//        loginLabel.setHeight(43)
        loginLabel.text = "Login"
        loginLabel.textAlignment = .left
        loginLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        loginLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureEmailTextField() {
        self.view.addSubview(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)])
        emailTextField.font = .systemFont(ofSize: 24, weight: .regular)
        emailTextField.textColor = .black
        emailTextField.textAlignment = .left
        emailTextField.pinTop(to: self.loginLabel.bottomAnchor, 80)
        emailTextField.pinLeft(to: self.view, 38)
        emailTextField.pinRight(to: self.view, 38)
//        emailTextField.setHeight(45)
        emailTextField.backgroundColor = .white
        emailTextField.borderStyle = .line
    }
    
    private func configurePasswordTextField() {
        self.view.addSubview(passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)])
        passwordTextField.font = .systemFont(ofSize: 24, weight: .regular)
        passwordTextField.textColor = .black
        passwordTextField.textAlignment = .left
        passwordTextField.pinTop(to: self.emailTextField.bottomAnchor, 33)
        passwordTextField.pinLeft(to: self.view, 38)
        passwordTextField.pinRight(to: self.view, 38)
//        passwordTextField.setHeight(45)
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .line
    }
    
    private func configureRegistrationButton() {
        self.view.addSubview(registrationButton)
        registrationButton.pinTop(to: self.passwordTextField.bottomAnchor, 25)
        registrationButton.pinRight(to: self.view, 38)
        registrationButton.setTitle("Registration", for: .normal)
        registrationButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        registrationButton.setTitleColor(.gray, for: .highlighted)
        registrationButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        registrationButton.addTarget(self, action: #selector(registrationButtonWasTapped), for: .touchDown)
    }
    
    private func configureEnterButton() {
        self.view.addSubview(enterButton)
        enterButton.pinTop(to: self.registrationButton.bottomAnchor, 40)
        enterButton.setHeight(70)
        enterButton.pinHorizontal(to: self.view, 38)
        enterButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8470588235, blue: 0.1058823529, alpha: 1)
        enterButton.layer.cornerRadius = 20
        enterButton.setTitle("Enter", for: .normal)
        enterButton.setTitleColor(#colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1), for: .normal)
        enterButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        enterButton.addTarget(self, action: #selector(enterButtonWasTapped), for: .touchDown)
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
}
