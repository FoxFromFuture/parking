//
//  UpdateAccountViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

// MARK: - UpdateAccountViewController
final class UpdateAccountViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: UpdateAccountBusinessLogic
    private let router: UpdateAccountRoutingLogic
    private let saveButton                       = UIButton()
    private let titleLabel                       = UILabel()
    private let subTitleLabel                    = UILabel()
    private let nameTextField                    = UITextField()
    private let emailTextField                   = UITextField()
    private let passwordTextField                = UITextField()
    private var nameTextFieldBottomBorder        = UIView()
    private var emailTextFieldBottomBorder       = UIView()
    private var passwordTextFieldBottomBorder    = UIView()
    private let accountUpdateFailureLabel        = UILabel()
    private let accountUpdateSuccessLabel        = UILabel()
    private var currentState: UpdateAccountState = .stable {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: UpdateAccountRoutingLogic,
        interactor: UpdateAccountBusinessLogic
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
        self.currentState = .stable
        interactor.loadStart(Model.Start.Request())
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureTitleLabel()
        configureSubTitleLabel()
        configureNameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureSaveButton()
        configureAccountUpdateFailureLabel()
        configureAccountUpdateSuccessLabel()
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
        titleLabel.text = "updateAccountTitle".localize()
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
        subTitleLabel.text = "updateAccountSubtitle".localize()
        subTitleLabel.textAlignment = .left
        subTitleLabel.textColor = Colors.secondaryText.uiColor
        subTitleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureNameTextField() {
        self.view.addSubview(nameTextField)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "name".localize(), attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryText.uiColor])
        nameTextField.font = .systemFont(ofSize: 24, weight: .regular)
        nameTextField.textColor = Colors.mainText.uiColor
        nameTextField.textAlignment = .left
        nameTextField.pinTop(to: self.subTitleLabel.bottomAnchor, 80)
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
    
    private func configureSaveButton() {
        self.view.addSubview(saveButton)
        saveButton.pinTop(to: self.passwordTextField.bottomAnchor, 70)
        saveButton.setHeight(70)
        saveButton.pinHorizontal(to: self.view, 38)
        saveButton.backgroundColor = Colors.accent.uiColor
        saveButton.layer.cornerRadius = 20
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        saveButton.addTarget(self, action: #selector(saveButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureAccountUpdateFailureLabel() {
        accountUpdateFailureLabel.text = "updateAccountFailure".localize()
        accountUpdateFailureLabel.textColor = Colors.danger.uiColor
        accountUpdateFailureLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    private func  configureAccountUpdateSuccessLabel() {
        accountUpdateSuccessLabel.text = "updateAccountSuccess".localize()
        accountUpdateSuccessLabel.textColor = Colors.success.uiColor
        accountUpdateSuccessLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadAccountDetails(Model.AccountDetails.Request())
    }
    
    @objc
    private func saveButtonWasTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            self.interactor.loadUpdateAccountRequest(UpdateAccountModel.UpdateAccountRequest.Request(name: name, email: email, password: password))
        }
    }
    
    private func showAccountUpdateFailure() {
        self.view.addSubview(accountUpdateFailureLabel)
        accountUpdateFailureLabel.pinTop(to: self.passwordTextField.bottomAnchor, 30)
        accountUpdateFailureLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        nameTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
        emailTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
        passwordTextFieldBottomBorder.backgroundColor = Colors.danger.uiColor
    }
    
    private func showAccountUpdateSuccess() {
        self.view.addSubview(accountUpdateSuccessLabel)
        accountUpdateSuccessLabel.pinTop(to: self.passwordTextField.bottomAnchor, 30)
        accountUpdateSuccessLabel.pinLeft(to: self.view.leadingAnchor, 38)
        
        nameTextFieldBottomBorder.backgroundColor = Colors.success.uiColor
        emailTextFieldBottomBorder.backgroundColor = Colors.success.uiColor
        passwordTextFieldBottomBorder.backgroundColor = Colors.success.uiColor
    }
}

// MARK: - DisplayLogic
extension UpdateAccountViewController: UpdateAccountDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayAccountDetails(_ viewModel: Model.AccountDetails.ViewModel) {
        self.router.routeToAccountDetails()
    }
    
    func displayUpdateAccountRequest(_ viewModel: Model.UpdateAccountRequest.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            if self?.currentState == .accountUpdateFailure {
                self?.accountUpdateFailureLabel.removeFromSuperview()
            }
            self?.currentState = .accountUpdateSuccess
        }
    }
    
    func displayUpdateAccountFailure(_ viewModel: Model.UpdateAccountFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            if self?.currentState == .accountUpdateSuccess {
                self?.accountUpdateSuccessLabel.removeFromSuperview()
            }
            self?.currentState = .accountUpdateFailure
        }
    }
}

// MARK: - UpdateUIForState
extension UpdateAccountViewController {
    func updateUIForState(_ state: UpdateAccountState) {
        switch state {
        case .stable:
            break
        case .accountUpdateFailure:
            showAccountUpdateFailure()
        case .accountUpdateSuccess:
            showAccountUpdateSuccess()
        }
    }
}
