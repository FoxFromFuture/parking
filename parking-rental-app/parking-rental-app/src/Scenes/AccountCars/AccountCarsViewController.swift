//
//  AccountCarsViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

import UIKit

// MARK: - AccountCarsViewController
final class AccountCarsViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: AccountCarsBusinessLogic
    private let router: AccountCarsRoutingLogic
    private let carsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let addNewCarButton = UIButton()
    private var cars: [Car]?
    private var isLimit: Bool?
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingFailureLabel = UILabel()
    private let reloadButton = UIButton()
    private var currentState: AccountCarsState = .loading {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: AccountCarsRoutingLogic,
        interactor: AccountCarsBusinessLogic
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentState == .error {
            loadingFailureLabel.removeFromSuperview()
            reloadButton.removeFromSuperview()
        }
        currentState = .loading
        self.cars = nil
        self.isLimit = nil
        self.reloadCollectionViewData()
        interactor.loadAccountCarsRequest(AccountCarsModel.AccountCarsRequest.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureCarsCollectionView()
        configureAddNewCarButton()
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
        navigationItem.title = "cars".localize()
    }
    
    private func configureCarsCollectionView() {
        self.view.addSubview(carsCollectionView)
        carsCollectionView.pinLeft(to: self.view.leadingAnchor)
        carsCollectionView.pinRight(to: self.view.trailingAnchor)
        carsCollectionView.pinTop(to: self.view.topAnchor)
        carsCollectionView.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        carsCollectionView.dataSource = self
        carsCollectionView.delegate = self
        carsCollectionView.backgroundColor = .clear
        carsCollectionView.contentInset.bottom = 120
        carsCollectionView.contentInset.top = 35
        carsCollectionView.register(CarCell.self, forCellWithReuseIdentifier: "CarCell")
    }
    
    private func configureAddNewCarButton() {
        self.view.addSubview(addNewCarButton)
        addNewCarButton.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor, 25)
        addNewCarButton.setHeight(70)
        addNewCarButton.pinHorizontal(to: self.view, 17)
        addNewCarButton.backgroundColor = Colors.secondaryButton.uiColor
        addNewCarButton.layer.cornerRadius = 20
        addNewCarButton.setTitle("addNewCar".localize(), for: .normal)
        addNewCarButton.setTitleColor(Colors.secondaryText.uiColor, for: .normal)
        addNewCarButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
    }
    
    private func setAddNewCarButtonDisable() {
        addNewCarButton.backgroundColor = Colors.secondaryButton.uiColor
        addNewCarButton.setTitleColor(Colors.secondaryText.uiColor, for: .normal)
        addNewCarButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    private func setAddNewCarButtonEnable() {
        addNewCarButton.backgroundColor = Colors.accent.uiColor
        addNewCarButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        addNewCarButton.addTarget(self, action: #selector(addNewCarButtonWasTapped), for: .touchUpInside)
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
        self.interactor.loadProfile(Model.Profile.Request())
    }
    
    @objc
    private func addNewCarButtonWasTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadAddCar(Model.AddCar.Request())
    }
    
    @objc
    private func reloadButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        loadingFailureLabel.removeFromSuperview()
        reloadButton.removeFromSuperview()
        currentState = .loading
        interactor.loadAccountCarsRequest(AccountCarsModel.AccountCarsRequest.Request())
    }
    
    private func showLoadingFailure() {
        view.addSubview(loadingFailureLabel)
        loadingFailureLabel.pinCenterX(to: self.view.centerXAnchor)
        loadingFailureLabel.pinTop(to: self.view, self.view.frame.height / 2.0 - 15)
        
        view.addSubview(reloadButton)
        reloadButton.pinTop(to: self.view, self.view.frame.height / 2.0 + 15)
        reloadButton.pinCenterX(to: self.view.centerXAnchor)
    }
    
    private func showCarsLimit() {
        self.setAddNewCarButtonDisable()
    }
    
    private func showAddCarActive() {
        self.setAddNewCarButtonEnable()
    }
}

// MARK: - DisplayLogic
extension AccountCarsViewController: AccountCarsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayProfile(_ viewModel: Model.Profile.ViewModel) {
        self.router.routeToProfile()
    }
    
    func displayAccountCarsRequest(_ viewModel: Model.AccountCarsRequest.ViewModel) {
        self.cars = viewModel.cars
        self.isLimit = viewModel.isLimit
        self.reloadCollectionViewData()
        
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            if viewModel.isLimit {
                self?.currentState = .carsLimit
            } else {
                self?.currentState = .addCarActive
            }
        }
    }
    
    func displayCarDetails(_ viewModel: Model.CarDetails.ViewModel) {
        self.router.routeToCarDetails(AccountCarsModel.CarDetails.RouteData(carID: viewModel.carID))
    }
    
    func displayAddCar(_ viewModel: Model.AddCar.ViewModel) {
        self.router.routeToAddCar()
    }
    
    func displayAccountCarsFailure(_ viewModel: Model.AccountCarsFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .error
        }
    }
}

// MARK: - CollectionView
extension AccountCarsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cars?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarCell", for: indexPath) as? CarCell else {
            return UICollectionViewCell()
        }
        cell.configure(
            model: self.cars?[indexPath.row].model ?? "",
            registryNumber: self.cars?[indexPath.row].registryNumber ?? ""
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 34, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let car = self.cars?[indexPath.row] {
            self.interactor.loadCarDetails(AccountCarsModel.CarDetails.Request(carID: car.id))
        }
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async { [weak self] in
            self?.carsCollectionView.reloadData()
        }
    }
}

// MARK: - UpdateUIForState
extension AccountCarsViewController {
    func updateUIForState(_ state: AccountCarsState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .error:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        case .carsLimit:
            showCarsLimit()
        case .addCarActive:
            showAddCarActive()
        }
    }
}
