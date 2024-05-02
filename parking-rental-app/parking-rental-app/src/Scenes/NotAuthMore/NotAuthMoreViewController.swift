//
//  NotAuthMoreViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/29/24.
//

import UIKit

// MARK: - NotAuthMoreViewController
final class NotAuthMoreViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: NotAuthMoreBusinessLogic
    private let router: NotAuthMoreRoutingLogic
    private let titleLabel = UILabel()
    private let settingsSingleCardButton = SingleCardButton()
    private let extrasView = MultipleButtonsCard()
    
    // MARK: - LifeCycle
    init(
        router: NotAuthMoreRoutingLogic,
        interactor: NotAuthMoreBusinessLogic
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
        configureTitleLabel()
        configureSettingsSingleCardButton()
        configureExtrasView()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 40)
        titleLabel.pinLeft(to: self.view.leadingAnchor, 17)
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
            self?.interactor.loadNotAuthSettings(Model.NotAuthSettings.Request())
        }
    }
    
    private func configureExtrasView() {
        self.view.addSubview(extrasView)
        extrasView.pinHorizontal(to: self.view, 17)
        extrasView.pinTop(to: self.settingsSingleCardButton.bottomAnchor, 40)
        extrasView.addButton(title: "contactDevsButton".localize(), activeValue: "") { [weak self] in
            self?.interactor.loadNotAuthContactDevs(NotAuthMoreModel.NotAuthContactDevs.Request())
        }
        extrasView.setTitle(title: "extras".localize())
        extrasView.setBottomText(text: "version".localize())
    }
}

// MARK: - DisplayLogic
extension NotAuthMoreViewController: NotAuthMoreDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayNotAuthSettings(_ viewModel: Model.NotAuthSettings.ViewModel) {
        self.router.routeToNotAuthSettings()
    }
    
    func displayNotAuthContactDevs(_ viewModel: Model.NotAuthContactDevs.ViewModel) {
        self.router.routeToNotAuthContactDevs()
    }
}

