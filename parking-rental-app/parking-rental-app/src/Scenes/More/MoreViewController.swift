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
    private let multipleButtonsCard = MultipleButtonsCard()
    private let languageChoiceAlert = UIAlertController(
        title: "changeLanguageAlert".localize(),
        message: nil,
        preferredStyle: .alert
    )
    private let themeChoiceAlert = UIAlertController()
    private var curTheme: Theme = .light
    
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
        configureMultipleButtonsCard()
        configureLanguageChoiceAlert()
        configureThemeChoiceAlert()
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
    
    private func configureLanguageChoiceAlert() {
        languageChoiceAlert.addAction(UIAlertAction(title: "settings".localize(), style: .default, handler: { (action: UIAlertAction!) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        languageChoiceAlert.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
    }
    
    private func configureThemeChoiceAlert() {
        themeChoiceAlert.addAction(UIAlertAction(title: "lightTheme".localize(), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadNewTheme(MoreModel.NewTheme.Request(theme: .light))
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "darkTheme".localize(), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadNewTheme(MoreModel.NewTheme.Request(theme: .dark))
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "systemTheme".localize(), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadNewTheme(MoreModel.NewTheme.Request(theme: .device))
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
    }
    
    private func configureMultipleButtonsCard() {
        self.view.addSubview(multipleButtonsCard)
        multipleButtonsCard.pinHorizontal(to: self.view, 17)
        multipleButtonsCard.pinTop(to: self.titleLabel.bottomAnchor, 30)
        multipleButtonsCard.addButton(title: "language".localize(), activeValue: "\(Language(rawValue: NSLocale.preferredLanguages.first ?? "en")?.expandedStr ?? "")") { [weak self] in
            self?.navigationController?.present(self?.languageChoiceAlert ?? UIAlertController(), animated: true)
        }
        multipleButtonsCard.addButton(title: "theme".localize(), activeValue: self.curTheme.str()) { [weak self] in
            self?.navigationController?.present(self?.themeChoiceAlert ?? UIAlertController(), animated: true)
        }
    }
    
    // MARK: - Actions
}

// MARK: - DisplayLogic
extension MoreViewController: MoreDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curTheme = viewModel.curTheme
        self.configureUI()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayNewTheme(_ viewModel: Model.NewTheme.ViewModel) {
        self.view.window?.overrideUserInterfaceStyle = viewModel.theme.getUserInterfaceStyle()
        self.multipleButtonsCard.setActiveValue(1, activeValue: viewModel.theme.str())
    }
}
