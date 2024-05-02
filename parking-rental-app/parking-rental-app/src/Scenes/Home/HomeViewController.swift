//
//  HomeViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: HomeBusinessLogic
    private let router: HomeRoutingLogic
    private let profileLabelButton = ProfileLabelButton()
    private let reserveLotButton = UIButton()
    private let reservationsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private var reservationsCount: Int?
    private var dates: [String]?
    private var startTimes: [String]?
    private var endTimes: [String]?
    private var lotNumbers: [String]?
    private var levelNumbers: [String]?
    private var buildingNames: [String]?
    private var reservationsIDx: [String]?
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingFailureLabel = UILabel()
    private let reloadButton = UIButton()
    private let noDataLabel = UILabel()
    private var currentState: HomeState = .loading {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: HomeRoutingLogic,
        interactor: HomeBusinessLogic
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
        if currentState == .noData {
            noDataLabel.removeFromSuperview()
        } else if currentState == .error {
            loadingFailureLabel.removeFromSuperview()
            reloadButton.removeFromSuperview()
        }
        self.reservationsCount = nil
        self.reloadCollectionViewData()
        currentState = .loading
        interactor.loadReservations(Model.GetReservations.Request())
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureProfileLabelButton()
        configureReservationsCollectionView()
        configureReserveLotButton()
        configureLoadingIndicator()
        configureLoadingFailureLabel()
        configureReloadButton()
        configureNoDataLabel()
    }
    
    private func configureProfileLabelButton() {
        view.addSubview(profileLabelButton)
        profileLabelButton.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        profileLabelButton.pinLeft(to: self.view.leadingAnchor, 17)
        let leftIconImage = UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        profileLabelButton.setLeftIcon(leftIconImage, Colors.mainText.uiColor)
        let rightIconImage = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)) ?? UIImage()
        profileLabelButton.setRightIcon(rightIconImage, Colors.icon.uiColor)
        profileLabelButton.setText("profile".localize(), Colors.mainText.uiColor, .systemFont(ofSize: 32, weight: .bold))
        profileLabelButton.pressAction = { [weak self] in
            self?.interactor.loadProfile(Model.Profile.Request())
        }
    }
    
    private func configureReservationsCollectionView() {
        self.view.addSubview(reservationsCollectionView)
        reservationsCollectionView.pinLeft(to: self.view.leadingAnchor)
        reservationsCollectionView.pinRight(to: self.view.trailingAnchor)
        reservationsCollectionView.pinTop(to: self.profileLabelButton.bottomAnchor)
        reservationsCollectionView.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        reservationsCollectionView.dataSource = self
        reservationsCollectionView.delegate = self
        reservationsCollectionView.backgroundColor = .clear
        reservationsCollectionView.contentInset.bottom = 120
        reservationsCollectionView.contentInset.top = 35
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        reservationsCollectionView.collectionViewLayout = layout
        reservationsCollectionView.register(ReservationCell.self, forCellWithReuseIdentifier: "ReservationCell")
    }
    
    private func configureReserveLotButton() {
        self.view.addSubview(reserveLotButton)
        reserveLotButton.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor, 25)
        reserveLotButton.setHeight(70)
        reserveLotButton.pinHorizontal(to: self.view, 17)
        reserveLotButton.backgroundColor = Colors.accent.uiColor
        reserveLotButton.layer.cornerRadius = 20
        reserveLotButton.setTitle("reserveLot".localize(), for: .normal)
        reserveLotButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        reserveLotButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        reserveLotButton.addTarget(self, action: #selector(reserveLotButtonWasTapped), for: .touchUpInside)
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
    
    private func configureNoDataLabel() {
        noDataLabel.text = "noReservations".localize()
        loadingFailureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        loadingFailureLabel.textColor = Colors.mainText.uiColor
    }
    
    // MARK: - Actions
    @objc
    private func reserveLotButtonWasTapped() {
        interactor.loadBuildings(Model.Buildings.Request())
    }
    
    @objc
    private func reloadButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        loadingFailureLabel.removeFromSuperview()
        reloadButton.removeFromSuperview()
        currentState = .loading
        interactor.loadReservations(Model.GetReservations.Request())
    }
    
    private func showLoadingFailure() {
        view.addSubview(loadingFailureLabel)
        loadingFailureLabel.pinCenterX(to: self.view.centerXAnchor)
        loadingFailureLabel.pinTop(to: self.view, self.view.frame.height / 2.0 - 15)
        
        view.addSubview(reloadButton)
        reloadButton.pinTop(to: self.view, self.view.frame.height / 2.0 + 15)
        reloadButton.pinCenterX(to: self.view.centerXAnchor)
    }
    
    private func showNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.pinCenter(to: self.view)
    }
}

// MARK: - DisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayReservations(_ viewModel: Model.GetReservations.ViewModel) {
        /// Retrieve data for reservationsCollectionView
        self.reservationsCount = viewModel.reservationsCount
        self.dates = viewModel.dates
        self.startTimes = viewModel.startTimes
        self.endTimes = viewModel.endTimes
        self.lotNumbers = viewModel.lotNumbets
        self.levelNumbers = viewModel.levelNumbers
        self.buildingNames = viewModel.buildingNames
        self.reservationsIDx = viewModel.reservationsIDx
        
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
        }
        
        self.reloadCollectionViewData()
    }
    
    func displayBuildings(_ viewModel: Model.Buildings.ViewModel) {
        self.router.routeToBuildings()
    }
    
    func displayMap(_ viewModel: Model.Map.ViewModel) {
        self.router.routeToMap(Model.Map.RouteData(reservationID: viewModel.reservationID))
    }
    
    func displayProfile(_ viewModel: Model.Profile.ViewModel) {
        self.router.routeToProfile()
    }
    
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .error
        }
    }
    
    func displayNoData(_ viewModel: Model.NoData.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .noData
        }
    }
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reservationsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
            return UICollectionViewCell()
        }
        cell.configure(
            lotNumber: self.lotNumbers?[indexPath.row] ?? "-",
            date: "\(self.dates?[indexPath.row] ?? "-"): \(self.startTimes?[indexPath.row] ?? "-") - \(self.endTimes?[indexPath.row] ?? "-")",
            floor: "\("floor".localize()): \(self.levelNumbers?[indexPath.row] ?? "-")",
            building: "\(self.buildingNames?[indexPath.row] ?? "-")"
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 34, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let reservationID = self.reservationsIDx?[indexPath.row] {
            interactor.loadMap(Model.Map.Request(reservationID: reservationID))
        }
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async { [weak self] in
            self?.reservationsCollectionView.reloadData()
        }
    }
}

// MARK: - UpdateUIForState
extension HomeViewController {
    func updateUIForState(_ state: HomeState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .error:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        case .noData:
            loadingIndicator.stopAnimating()
            self.showNoDataLabel()
        }
    }
}
