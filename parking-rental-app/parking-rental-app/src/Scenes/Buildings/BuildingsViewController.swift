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
    private var buildingsCount: Int?
    private var buildingNames: [String]?
    private var buildingAddresses: [String]?
    private var buildingsIDx: [String]?
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingFailureLabel = UILabel()
    private let reloadButton = UIButton()
    private var currentState: BuildingsState = .loading {
        didSet {
            updateUIForState(currentState)
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentState == .error {
            loadingFailureLabel.removeFromSuperview()
            reloadButton.removeFromSuperview()
        }
        currentState = .loading
        interactor.loadBuildings(Model.GetBuildings.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureNavigationBar()
        configureAvailableBuildingsLabel()
        configureTabBar()
        configureBuildingsCollectionView()
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
    
    private func configureLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.pinCenter(to: self.view)
        loadingIndicator.color = .gray
    }
    
    private func configureLoadingFailureLabel() {
        loadingFailureLabel.text = "Connection Error"
        loadingFailureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        loadingFailureLabel.textColor = .black
    }
    
    private func configureReloadButton() {
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.setTitleColor(.systemBlue, for: .normal)
        reloadButton.setTitleColor(.gray, for: .highlighted)
        reloadButton.backgroundColor = UIColor.clear
        reloadButton.addTarget(self, action: #selector(reloadButtonWasPressed), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    public func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadHome(Model.Home.Request())
    }
    
    @objc
    public func reloadButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        loadingFailureLabel.removeFromSuperview()
        reloadButton.removeFromSuperview()
        currentState = .loading
        interactor.loadBuildings(Model.GetBuildings.Request())
    }
    
    private func showLoadingFailure() {
        view.addSubview(loadingFailureLabel)
        loadingFailureLabel.pinCenterX(to: self.view.centerXAnchor)
        loadingFailureLabel.pinTop(to: self.view, self.view.frame.height / 2.0 - 15)
        
        view.addSubview(reloadButton)
        reloadButton.pinTop(to: self.view, self.view.frame.height / 2.0 + 15)
        reloadButton.pinCenterX(to: self.view.centerXAnchor)
    }
}

// MARK: - DisplayLogic
extension BuildingsViewController: BuildingsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayBuildings(_ viewModel: Model.GetBuildings.ViewModel) {
        /// Retrieve data for reservationsCollectionView
        self.buildingsCount = viewModel.buildingsCount
        self.buildingNames = viewModel.buildingNames
        self.buildingAddresses = viewModel.buildingAddresses
        self.buildingsIDx = viewModel.buildingsIDx
        
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
        }
        
        self.reloadCollectionViewData()
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
    
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .error
        }
    }
}

// MARK: - CollectionView
extension BuildingsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.buildingsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuildingCell", for: indexPath) as? BuildingCell else {
            return UICollectionViewCell()
        }
        cell.configure(
            buildingName: buildingNames?[indexPath.row] ?? "-",
            workHours: "08:00 - 22:00",
            address: buildingAddresses?[indexPath.row] ?? "-"
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 34, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.loadMap(Model.Map.Request(buildingID: self.buildingsIDx?[indexPath.row]))
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async { [weak self] in
            self?.buildingsCollectionView.reloadData()
        }
    }
}

// MARK: - UpdateUIForState
extension BuildingsViewController {
    func updateUIForState(_ state: BuildingsState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .error:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        }
    }
}
