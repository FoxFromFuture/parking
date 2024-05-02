//
//  ContactDevsViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/27/24.
//

import UIKit

// MARK: - ContactDevsViewController
final class ContactDevsViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: ContactDevsBusinessLogic
    private let router: ContactDevsRoutingLogic
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let githubButton = ImageButton()
    
    // MARK: - LifeCycle
    init(
        router: ContactDevsRoutingLogic,
        interactor: ContactDevsBusinessLogic
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
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor.withAlphaComponent(0.93)
        configureCloseButton()
        configureTitleLabel()
        configureGithubButton()
    }
    
    private func configureCloseButton() {
        self.view.addSubview(closeButton)
        closeButton.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
        closeButton.pinLeft(to: self.view.leadingAnchor, 20)
        closeButton.setTitle("close".localize(), for: .normal)
        closeButton.setTitleColor(Colors.active.uiColor, for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        closeButton.addTarget(self, action: #selector(closeButtonWasTapped), for: .touchUpInside)
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.pinCenterY(to: self.closeButton.centerYAnchor, -1)
        titleLabel.pinCenterX(to: self.view.centerXAnchor)
        titleLabel.text = "contactDevsTitle".localize()
        titleLabel.textColor = Colors.mainText.uiColor
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private func configureGithubButton() {
        self.view.addSubview(githubButton)
        githubButton.pinCenterX(to: self.view.centerXAnchor)
        githubButton.pinCenterY(to: self.view.centerYAnchor)
        githubButton.setText("GitHub", Colors.mainText.uiColor, .systemFont(ofSize: 20, weight: .medium))
        githubButton.setIcon(UIImage(systemName: "link.circle.fill") ?? UIImage(), Colors.active.uiColor, height: 80, width: 80)
        githubButton.pressAction = { [weak self] in
            self?.interactor.loadGitHubLink(ContactDevsModel.GitHubLink.Request())
        }
    }
    
    // MARK: - Actions
    @objc
    private func closeButtonWasTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadMore(Model.More.Request())
    }
}

// MARK: - DisplayLogic
extension ContactDevsViewController: ContactDevsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
    
    func displayGitHubLink(_ viewModel: Model.GitHubLink.ViewModel) {
        self.router.routeToGitHubLink()
    }
}
