//
//  MapViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

// MARK: - MapViewController
final class MapViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: MapBusinessLogic
    private let router: MapRoutingLogic
    private let tabBar = TabBar()
    private let mapScrollView = UIScrollView()
    private let mapView = MapView()
    
    // MARK: - LifeCycle
    init(
        router: MapRoutingLogic,
        interactor: MapBusinessLogic
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
        configureTabBar()
        configureMapScrollView()
        configureMapView()
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
    
    private func configureMapScrollView() {
        view.addSubview(mapScrollView)
        mapScrollView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mapScrollView.isScrollEnabled = true
        mapScrollView.isMultipleTouchEnabled = true
        mapScrollView.minimumZoomScale = 1.0
        mapScrollView.maximumZoomScale = 6.0
        mapScrollView.delegate = self
    }
    
    private func configureMapView() {
        mapScrollView.addSubview(mapView)
    }
    
    // MARK: - Actions
    @objc
    public func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadPreviousScene(Model.PreviousScene.Request())
    }
}

// MARK: - DisplayLogic
extension MapViewController: MapDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayPreviousScene(_ viewModel: Model.PreviousScene.ViewModel) {
        self.router.routeToPreviousScene()
    }
}

extension MapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return mapView
        }
}
