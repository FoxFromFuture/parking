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
    private let languageChoiceAlert = UIAlertController()
    private let themeChoiceAlert = UIAlertController()
    
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
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
        titleLabel.text = "More"
        titleLabel.textAlignment = .left
        titleLabel.textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    private func configureLanguageChoiceAlert() {
        languageChoiceAlert.addAction(UIAlertAction(title: "English", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            
        }))
        languageChoiceAlert.addAction(UIAlertAction(title: "Russian", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            
        }))
        languageChoiceAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    private func configureThemeChoiceAlert() {
        themeChoiceAlert.addAction(UIAlertAction(title: "Always light mode", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "Always dark mode", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "Use system settings", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            
        }))
        themeChoiceAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    private func configureMultipleButtonsCard() {
        self.view.addSubview(multipleButtonsCard)
        multipleButtonsCard.pinHorizontal(to: self.view, 17)
        multipleButtonsCard.pinTop(to: self.titleLabel.bottomAnchor, 30)
        multipleButtonsCard.addButton(title: "Language", activeValue: "English") { [weak self] in
            self?.navigationController?.present(self?.languageChoiceAlert ?? UIAlertController(), animated: true)
        }
        multipleButtonsCard.addButton(title: "Theme", activeValue: "Light") { [weak self] in
            self?.navigationController?.present(self?.themeChoiceAlert ?? UIAlertController(), animated: true)
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
}
