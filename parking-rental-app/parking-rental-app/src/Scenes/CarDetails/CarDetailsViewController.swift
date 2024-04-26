//
//  CarDetailsViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit

// MARK: - CarDetailsViewController
final class CarDetailsViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: CarDetailsBusinessLogic
    private let router: CarDetailsRoutingLogic
    private let carIDForPresent: String
    private let tabBar = TabBar()
    private let modelDetailsCardButton = DetailsCardButton()
    private let registryNumberDetailsCardButton = DetailsCardButton()
    private let deleteCarButton = UIButton()
    private let deleteCarAlert = UIAlertController()
    private let updateDetailsButton = UIButton()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingFailureLabel = UILabel()
    private let reloadButton = UIButton()
    private var currentState: CarDetailsState = .loading {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: CarDetailsRoutingLogic,
        interactor: CarDetailsBusinessLogic,
        carID: String
    ) {
        self.router = router
        self.interactor = interactor
        self.carIDForPresent = carID
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentState == .error {
            loadingFailureLabel.removeFromSuperview()
            reloadButton.removeFromSuperview()
        }
        currentState = .loading
        interactor.loadCarDetails(CarDetailsModel.CarDetails.Request(carID: self.carIDForPresent))
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureTabBar()
        configureDeleteCarButton()
        configureDeleteCarAlert()
        configureUpdateDetailsButton()
        configureLoadingIndicator()
        configureLoadingFailureLabel()
        configureReloadButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.active.uiColor
        navigationItem.title = "carDetails".localize()
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
    
    private func configureModelDetailsCardButton(model: String) {
        self.view.addSubview(modelDetailsCardButton)
        modelDetailsCardButton.pinHorizontal(to: self.view, 17)
        modelDetailsCardButton.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 20)
        modelDetailsCardButton.setLeftIcon(icon: "car.fill")
        modelDetailsCardButton.hideRightIcon()
        modelDetailsCardButton.setTitle(title: model)
    }
    
    private func configureRegistryNumberDetailsCardButton(registryNumber: String) {
        self.view.addSubview(registryNumberDetailsCardButton)
        registryNumberDetailsCardButton.pinHorizontal(to: self.view, 17)
        registryNumberDetailsCardButton.pinTop(to: self.modelDetailsCardButton.bottomAnchor)
        registryNumberDetailsCardButton.setLeftIcon(icon: "123.rectangle")
        registryNumberDetailsCardButton.hideRightIcon()
        registryNumberDetailsCardButton.setTitle(title: registryNumber)
    }
    
    private func configureDeleteCarButton() {
        self.view.addSubview(deleteCarButton)
        deleteCarButton.pinBottom(to: self.tabBar.topAnchor, 25)
        deleteCarButton.setHeight(70)
        deleteCarButton.pinHorizontal(to: self.view, 17)
        deleteCarButton.backgroundColor = Colors.secondaryButton.uiColor
        deleteCarButton.layer.cornerRadius = 20
        deleteCarButton.setTitle("deleteCar".localize(), for: .normal)
        deleteCarButton.setTitleColor(Colors.secondaryText.uiColor, for: .normal)
        deleteCarButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
    }
    
    private func setDeleteCarButtonDisable() {
        deleteCarButton.setTitleColor(Colors.secondaryText.uiColor, for: .normal)
        deleteCarButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    private func setDeleteCarButtonEnable() {
        deleteCarButton.setTitleColor(Colors.danger.uiColor, for: .normal)
        deleteCarButton.addTarget(self, action: #selector(deleteCarButtonWasTapped), for: .touchDown)
    }
    
    private func configureDeleteCarAlert() {
        deleteCarAlert.message = "deleteCarQuestion".localize()
        deleteCarAlert.addAction(UIAlertAction(title: "deleteCar".localize(), style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadDeleteCar(CarDetailsModel.DeleteCar.Request(carID: self?.carIDForPresent ?? ""))
        }))
        deleteCarAlert.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
    }
    
    private func configureUpdateDetailsButton() {
        self.view.addSubview(updateDetailsButton)
        updateDetailsButton.pinBottom(to: self.deleteCarButton.topAnchor, 20)
        updateDetailsButton.setHeight(70)
        updateDetailsButton.pinHorizontal(to: self.view, 17)
        updateDetailsButton.backgroundColor = Colors.secondaryButton.uiColor
        updateDetailsButton.layer.cornerRadius = 20
        updateDetailsButton.setTitle("updateCarDetails".localize(), for: .normal)
        updateDetailsButton.setTitleColor(Colors.active.uiColor, for: .normal)
        updateDetailsButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        updateDetailsButton.addTarget(self, action: #selector(updateDetailsButtonWasTapped), for: .touchDown)
    }
    
    private func configureLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.pinCenter(to: self.view)
        loadingIndicator.color = Colors.secondaryText.uiColor
    }
    
    private func configureLoadingFailureLabel() {
        loadingFailureLabel.text = "connectionError".localize()
        loadingFailureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        loadingFailureLabel.textColor = Colors.mainText.uiColor
    }
    
    private func configureReloadButton() {
        reloadButton.setTitle("reload".localize(), for: .normal)
        reloadButton.setTitleColor(Colors.active.uiColor, for: .normal)
        reloadButton.setTitleColor(Colors.secondaryText.uiColor, for: .highlighted)
        reloadButton.backgroundColor = .clear
        reloadButton.addTarget(self, action: #selector(reloadButtonWasPressed), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadAccountCars(CarDetailsModel.AccountCars.Request())
    }
    
    @objc
    private func deleteCarButtonWasTapped() {
        self.navigationController?.present(deleteCarAlert, animated: true)
    }
    
    @objc
    private func updateDetailsButtonWasTapped() {
        self.interactor.loadUpdateCar(CarDetailsModel.UpdateCar.Request(carID: self.carIDForPresent))
    }
    
    @objc
    private func reloadButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        loadingFailureLabel.removeFromSuperview()
        reloadButton.removeFromSuperview()
        currentState = .loading
        interactor.loadCarDetails(CarDetailsModel.CarDetails.Request(carID: self.carIDForPresent))
    }
    
    private func showLoadingFailure() {
        view.addSubview(loadingFailureLabel)
        loadingFailureLabel.pinCenterX(to: self.view.centerXAnchor)
        loadingFailureLabel.pinTop(to: self.view, self.view.frame.height / 2.0 - 15)
        
        view.addSubview(reloadButton)
        reloadButton.pinTop(to: self.view, self.view.frame.height / 2.0 + 15)
        reloadButton.pinCenterX(to: self.view.centerXAnchor)
    }
    
    private func showDeleteCarLimit() {
        self.setDeleteCarButtonDisable()
    }
    
    private func showDeleteCarActive() {
        self.setDeleteCarButtonEnable()
    }
}

// MARK: - DisplayLogic
extension CarDetailsViewController: CarDetailsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayCarDetails(_ viewModel: Model.CarDetails.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            self?.configureModelDetailsCardButton(model: viewModel.model)
            self?.configureRegistryNumberDetailsCardButton(registryNumber: viewModel.registryNumber)
            if viewModel.isOnlyOneCarLasts {
                self?.currentState = .deleteCarLimit
            } else {
                self?.currentState = .deleteCarActive
            }
        }
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayAccountCars(_ viewModel: Model.AccountCars.ViewModel) {
        self.router.routeToAccountCars()
    }
    
    func displayUpdateCar(_ viewModel: Model.UpdateCar.ViewModel) {
        self.router.routeToUpdateCar(CarDetailsModel.UpdateCar.RouteData(carID: viewModel.carID))
    }
    
    func displayDeleteCar(_ viewModel: Model.DeleteCar.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToAccountCars()
        }
    }
    
    func displayCarDetailsFailure(_ viewModel: Model.CarDetailsFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .error
        }
    }
}

// MARK: - UpdateUIForState
extension CarDetailsViewController {
    func updateUIForState(_ state: CarDetailsState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .error:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        case .deleteCarLimit:
            showDeleteCarLimit()
        case .deleteCarActive:
            showDeleteCarActive()
        }
    }
}
