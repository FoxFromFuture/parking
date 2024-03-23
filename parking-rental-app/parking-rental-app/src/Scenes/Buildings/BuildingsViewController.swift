//
//  BuildingsViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

// MARK: - BuildingsViewController
final class BuildingsViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: BuildingsBusinessLogic
    private let router: BuildingsRoutingLogic
    private let availableBuildingsLabel = UILabel()
    private let tabBar = TabBar()
    private let buildingsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - LifeCycle
    init(
        router: BuildingsRoutingLogic,
        interactor: BuildingsBusinessLogic
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
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureNavigationBar()
        configureAvailableBuildingsLabel()
        configureTabBar()
        configureBuildingsCollectionView()
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
    
    private func configureAvailableBuildingsLabel() {
        self.view.addSubview(availableBuildingsLabel)
        availableBuildingsLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
        availableBuildingsLabel.pinLeft(to: self.view.leadingAnchor, 17)
        availableBuildingsLabel.setHeight(45)
        availableBuildingsLabel.text = "Available Buildings"
        availableBuildingsLabel.textAlignment = .left
        availableBuildingsLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        availableBuildingsLabel.font = .systemFont(ofSize: 36, weight: .bold)
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
    
    private func configureBuildingsCollectionView() {
        self.view.addSubview(buildingsCollectionView)
        buildingsCollectionView.pinLeft(to: self.view.leadingAnchor, 17)
        buildingsCollectionView.pinRight(to: self.view.trailingAnchor, 17)
        buildingsCollectionView.pinTop(to: self.availableBuildingsLabel.bottomAnchor, 35)
        buildingsCollectionView.pinBottom(to: self.tabBar.topAnchor)
        buildingsCollectionView.dataSource = self
        buildingsCollectionView.delegate = self
        buildingsCollectionView.backgroundColor = .clear
        buildingsCollectionView.contentInset.bottom = 120
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        buildingsCollectionView.collectionViewLayout = layout
        buildingsCollectionView.register(BuildingCell.self, forCellWithReuseIdentifier: "BuildingCell")
    }
    
    // MARK: - Actions
    @objc
    public func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadHome(Model.Home.Request())
    }
}

// MARK: - DisplayLogic
extension BuildingsViewController: BuildingsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayMap(_ viewModel: Model.Map.ViewModel) {
        self.router.routeToMap()
    }
}

// MARK: - CollectionView
extension BuildingsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BuildingsDataStore.shared.buildings?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuildingCell", for: indexPath) as? BuildingCell else {
            return UICollectionViewCell()
        }
        cell.configure(
            buildingName: BuildingsDataStore.shared.buildings?[indexPath.row].name ?? "-",
            workHours: "08:00 - 22:00",
            address: BuildingsDataStore.shared.buildings?[indexPath.row].address ?? "-"
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 34, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.loadMap(Model.Map.Request(selectedBuilding: BuildingsDataStore.shared.buildings![indexPath.row]))
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async { [weak self] in
            self?.buildingsCollectionView.reloadData()
        }
    }
}

