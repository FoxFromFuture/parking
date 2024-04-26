//
//  MoreViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

// MARK: - MoreViewController
final class MoreViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: MoreBusinessLogic
    private let router: MoreRoutingLogic
    private let tabBar = TabBar()
    private let titleLabel = UILabel()
    private let settingsSingleCardButton = SingleCardButton()
    private let FAQSingleCardButton = SingleCardButton()
    
    // MARK: - LifeCycle
    init(
        router: MoreRoutingLogic,
        interactor: MoreBusinessLogic
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
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureTabBar()
        configureTitleLabel()
        configureSettingsSingleCardButton()
        configureFAQSingleCardButton()
    }
    
    private func configureTabBar() {
        view.addSubview(tabBar)
        tabBar.pinBottom(to: self.view.bottomAnchor)
        tabBar.pinLeft(to: self.view.leadingAnchor)
        tabBar.pinRight(to: self.view.trailingAnchor)
        tabBar.setHeight(92)
        tabBar.setHomeButtonAction { [weak self] in
            self?.interactor.loadHome(Model.Home.Request())
        }
        tabBar.setMoreButtonActive()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 17)
        titleLabel.setHeight(45)
        titleLabel.text = "more".localize()
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureSettingsSingleCardButton() {
        self.view.addSubview(settingsSingleCardButton)
        settingsSingleCardButton.pinTop(to: self.titleLabel.bottomAnchor, 30)
        settingsSingleCardButton.pinHorizontal(to: self.view, 17)
        settingsSingleCardButton.configure(title: "settings".localize(), subtitle: "settingsDetails".localize())
        settingsSingleCardButton.setAction { [weak self] in
            self?.interactor.loadSettings(MoreModel.Settings.Request())
        }
    }
    
    private func configureFAQSingleCardButton() {
        self.view.addSubview(FAQSingleCardButton)
        FAQSingleCardButton.pinTop(to: self.settingsSingleCardButton.bottomAnchor, 25)
        FAQSingleCardButton.pinHorizontal(to: self.view, 17)
        FAQSingleCardButton.configure(title: "FAQ".localize(), subtitle: "FAQDetails".localize())
        FAQSingleCardButton.setAction { [weak self] in
            self?.interactor.loadFAQ(MoreModel.FAQ.Request())
        }
    }
    
    // MARK: - Actions
}

// MARK: - DisplayLogic
extension MoreViewController: MoreDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displaySettings(_ viewModel: Model.Settings.ViewModel) {
        self.router.routeToSettings()
    }
    
    func displayFAQ(_ viewModel: Model.FAQ.ViewModel) {
        self.router.routeToFAQ()
    }
}
