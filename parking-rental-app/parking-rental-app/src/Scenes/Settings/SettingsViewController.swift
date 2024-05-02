//
//  SettingsViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

// MARK: - SettingsViewController
final class SettingsViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: SettingsBusinessLogic
    private let router: SettingsRoutingLogic
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
        router: SettingsRoutingLogic,
        interactor: SettingsBusinessLogic
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
        view.backgroundColor = Colors.background.uiColor
        configureNavigationBar()
        configureMultipleButtonsCard()
        configureLanguageChoiceAlert()
        configureThemeChoiceAlert()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.active.uiColor
        navigationItem.title = "settings".localize()
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
            self?.interactor.loadNewTheme(Model.NewTheme.Request(theme: .light))
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "darkTheme".localize(), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadNewTheme(Model.NewTheme.Request(theme: .dark))
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "systemTheme".localize(), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.interactor.loadNewTheme(Model.NewTheme.Request(theme: .device))
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
    }
    
    private func configureMultipleButtonsCard() {
        self.view.addSubview(multipleButtonsCard)
        multipleButtonsCard.pinHorizontal(to: self.view, 17)
        multipleButtonsCard.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 30)
        multipleButtonsCard.addButton(title: "language".localize(), activeValue: "\(Language(rawValue: NSLocale.preferredLanguages.first ?? "en")?.expandedStr ?? "")") { [weak self] in
            self?.navigationController?.present(self?.languageChoiceAlert ?? UIAlertController(), animated: true)
        }
        multipleButtonsCard.addButton(title: "theme".localize(), activeValue: self.curTheme.str()) { [weak self] in
            self?.navigationController?.present(self?.themeChoiceAlert ?? UIAlertController(), animated: true)
        }
        multipleButtonsCard.deleteTitle()
        multipleButtonsCard.deleteBottomText()
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadMore(SettingsModel.More.Request())
    }
}

// MARK: - DisplayLogic
extension SettingsViewController: SettingsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curTheme = viewModel.curTheme
        self.configureUI()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayNewTheme(_ viewModel: Model.NewTheme.ViewModel) {
        self.view.window?.overrideUserInterfaceStyle = viewModel.theme.getUserInterfaceStyle()
        self.multipleButtonsCard.setActiveValue(1, activeValue: viewModel.theme.str())
    }
}
