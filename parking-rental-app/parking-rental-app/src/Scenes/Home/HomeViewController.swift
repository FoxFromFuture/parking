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
    private let tabBar = TabBar()
    private let profileLabelButton = ProfileLabelButton()
    private let reserveLotButton = UIButton()
    private let reservationsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let reservationsDataStore = ReservationsDataStore.shared
    private let parkingSpotsDataStore = ParkingSpotsDataStore.shared
    private var spotNumbers: [String]?
    private var levelNumbers: [String]?
    private var buildingNames: [String]?
    
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
        interactor.loadReservations(Model.GetReservations.Request())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureTabBar()
        configureProfileLabelButton()
        configureReservationsCollectionView()
        configureReserveLotButton()
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
    }
    
    private func configureProfileLabelButton() {
        view.addSubview(profileLabelButton)
        profileLabelButton.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        profileLabelButton.pinLeft(to: self.view.leadingAnchor, 17)
        let leftIconImage = UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        profileLabelButton.setLeftIcon(leftIconImage, #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1))
        let rightIconImage = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)) ?? UIImage()
        profileLabelButton.setRightIcon(rightIconImage, #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1))
        profileLabelButton.setText("Profile", #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1), .systemFont(ofSize: 32, weight: .bold))
        profileLabelButton.pressAction = { [weak self] in
            self?.interactor.loadProfile(Model.Profile.Request())
        }
    }
    
    private func configureReservationsCollectionView() {
        self.view.addSubview(reservationsCollectionView)
        reservationsCollectionView.pinLeft(to: self.view.leadingAnchor, 17)
        reservationsCollectionView.pinRight(to: self.view.trailingAnchor, 17)
        reservationsCollectionView.pinTop(to: self.profileLabelButton.bottomAnchor, 35)
        reservationsCollectionView.pinBottom(to: self.tabBar.topAnchor)
        reservationsCollectionView.dataSource = self
        reservationsCollectionView.delegate = self
        reservationsCollectionView.backgroundColor = .clear
        reservationsCollectionView.contentInset.bottom = 120
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        reservationsCollectionView.collectionViewLayout = layout
        reservationsCollectionView.register(ReservationCell.self, forCellWithReuseIdentifier: "ReservationCell")
    }
    
    private func configureReserveLotButton() {
        self.view.addSubview(reserveLotButton)
        reserveLotButton.pinBottom(to: self.tabBar.topAnchor, 25)
        reserveLotButton.setHeight(70)
        reserveLotButton.pinHorizontal(to: self.view, 17)
        reserveLotButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.8470588235, blue: 0.1058823529, alpha: 1)
        reserveLotButton.layer.cornerRadius = 20
        reserveLotButton.setTitle("Reserve Lot", for: .normal)
        reserveLotButton.setTitleColor(#colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1), for: .normal)
        reserveLotButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
        reserveLotButton.addTarget(self, action: #selector(reserveLotButtonWasTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    @objc
    private func reserveLotButtonWasTapped() {
        interactor.loadBuildings(Model.Buildings.Request())
    }
}

// MARK: - DisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayReservations(_ viewModel: Model.GetReservations.ViewModel) {
        self.spotNumbers = viewModel.spotNumbers
        self.levelNumbers = viewModel.levelNumbers
        self.buildingNames = viewModel.buildingNames
        self.reloadCollectionViewData()
    }
    
    func displayBuildings(_ viewModel: Model.Buildings.ViewModel) {
        self.router.routeToBuildings()
    }
    
    func displayMap(_ viewModel: Model.Map.ViewModel) {
        self.router.routeToMap()
    }
    
    func displayProfile(_ viewModel: Model.Profile.ViewModel) {
        self.router.routeToProfile()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reservationsDataStore.reservations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
            return UICollectionViewCell()
        }
        cell.configure(
            lotNumber: "\(self.spotNumbers?[indexPath.row] ?? "-")",
            date: "\(reservationsDataStore.reservations?[indexPath.row].startTime.prefix(10) ?? "-"): \(reservationsDataStore.reservations?[indexPath.row].startTime.suffix(8).prefix(5) ?? "-") - \(reservationsDataStore.reservations?[indexPath.row].endTime.suffix(8).prefix(5) ?? "-")",
            floor: "Floor: \(self.levelNumbers?[indexPath.row] ?? "-")",
            building: "\(self.buildingNames?[indexPath.row] ?? "-")"
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 34, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - fetch spot id to view on map
//        interactor.loadMap(Model.Map.Request(lotID: <#T##String#>))
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async { [weak self] in
            self?.reservationsCollectionView.reloadData()
        }
    }
}
