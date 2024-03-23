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
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureTitleLabel()
        configureSubTitleLabel()
        configureCarRegistryNumberTextFieldTextField()
        configureContinueButton()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleLabel.pinRight(to: self.view.trailingAnchor, 38)
        titleLabel.text = "Set your car\nregistry number"
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
        subTitleLabel.text = "To make reservations for it"
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
    
    private func configureContinueButton() {
        self.view.addSubview(continueButton)
        continueButton.pinTop(to: self.carRegistryNumberTextField.bottomAnchor, 40)
        continueButton.setHeight(70)
        continueButton.pinHorizontal(to: self.view, 38)
        continueButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8470588235, blue: 0.1058823529, alpha: 1)
        continueButton.layer.cornerRadius = 20
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(#colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1), for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        continueButton.addTarget(self, action: #selector(continueButtonWasTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    @objc
    private func continueButtonWasTapped() {
        if let carRegistryNumber = carRegistryNumberTextField.text {
            interactor.loadHome(Model.Home.Request(carRegistryNumber: carRegistryNumber))
        }
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
}


