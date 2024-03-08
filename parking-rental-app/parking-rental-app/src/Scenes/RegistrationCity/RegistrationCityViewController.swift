//
//  RegistrationCityViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

// MARK: - RegistrationCityViewController
final class RegistrationCityViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: RegistrationCityBusinessLogic
    private let router: RegistrationCityRoutingLogic
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let cityButton = UIButton()
    private let continueButton = UIButton()
    private var choosenCity = "Nizhny Novgorod"
    
    // MARK: - LifeCycle
    init(
        router: RegistrationCityRoutingLogic,
        interactor: RegistrationCityBusinessLogic
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
        configureCityButton()
        configureContinueButton()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 35)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleLabel.pinRight(to: self.view.trailingAnchor, 38)
        titleLabel.text = "Choose\nyour city"
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
        subTitleLabel.text = "To know your parking buildings"
        subTitleLabel.textAlignment = .left
        subTitleLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        subTitleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureCityButton() {
        self.view.addSubview(cityButton)
        cityButton.pinTop(to: self.subTitleLabel.bottomAnchor, 60)
        cityButton.pinLeft(to: self.view, 38)
        cityButton.pinRight(to: self.view, 38)
        cityButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        cityButton.setTitleColor(.gray, for: .highlighted)
        cityButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        cityButton.menu = UIMenu(children: [
            UIAction(title: "Nizhny Novgorod", state: .on, handler: { [weak self] action in
                self?.choosenCity = "Nizhny Novgorod"
            }),
            UIAction(title: "Moscow", handler: { [weak self] action in
                self?.choosenCity = "Moscow"
            }),
        ])
        cityButton.showsMenuAsPrimaryAction = true
        cityButton.changesSelectionAsPrimaryAction = true
    }
    
    private func configureContinueButton() {
        self.view.addSubview(continueButton)
        continueButton.pinTop(to: self.cityButton.bottomAnchor, 40)
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
        interactor.loadRegistrationCar(Model.RegistrationCar.Request(city: self.choosenCity))
    }
}

// MARK: - DisplayLogic
extension RegistrationCityViewController: RegistrationCityDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayRegistrationCar(_ viewModel: RegistrationCityModel.RegistrationCar.ViewModel) {
        router.routeToRegistrationCar()
    }
}

