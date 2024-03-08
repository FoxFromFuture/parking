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
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureNavigationBar()
        configureRegistrationLabel()
        configureNameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureRegisterButton()
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
    
    private func configureRegistrationLabel() {
        self.view.addSubview(registrationLabel)
        registrationLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 35)
        registrationLabel.pinLeft(to: self.view.leadingAnchor, 38)
        registrationLabel.pinRight(to: self.view.trailingAnchor, 38)
//        registrationLabel.setHeight(43)
        registrationLabel.text = "Registration"
        registrationLabel.textAlignment = .left
        registrationLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        registrationLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureNameTextField() {
        self.view.addSubview(nameTextField)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)])
        nameTextField.font = .systemFont(ofSize: 24, weight: .regular)
        nameTextField.textColor = .black
        nameTextField.textAlignment = .left
        nameTextField.pinTop(to: self.registrationLabel.bottomAnchor, 80)
        nameTextField.pinLeft(to: self.view, 38)
        nameTextField.pinRight(to: self.view, 38)
//        nameTextField.setHeight(45)
        nameTextField.backgroundColor = .white
        nameTextField.borderStyle = .line
    }
    
    private func configureEmailTextField() {
        self.view.addSubview(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)])
        emailTextField.font = .systemFont(ofSize: 24, weight: .regular)
        emailTextField.textColor = .black
        emailTextField.textAlignment = .left
        emailTextField.pinTop(to: self.nameTextField.bottomAnchor, 33)
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
    
    private func configureRegisterButton() {
        self.view.addSubview(registerButton)
        registerButton.pinTop(to: self.passwordTextField.bottomAnchor, 40)
        registerButton.setHeight(70)
        registerButton.pinHorizontal(to: self.view, 38)
        registerButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8470588235, blue: 0.1058823529, alpha: 1)
        registerButton.layer.cornerRadius = 20
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(#colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1), for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        registerButton.addTarget(self, action: #selector(registerButtonWasTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    @objc
    public func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @objc
    private func registerButtonWasTapped() {
        /// TODO: Check is textFields contain characters
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            interactor.loadRegistrationCity(Model.RegistrationCity.Request(name: name, email: email, password: password))
        }
    }
}

// MARK: - DisplayLogic
extension RegistrationViewController: RegistrationDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayRegistrationCity(_ viewModel: RegistrationModel.RegistrationCity.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToRegistrationCity()
        }
    }
}
