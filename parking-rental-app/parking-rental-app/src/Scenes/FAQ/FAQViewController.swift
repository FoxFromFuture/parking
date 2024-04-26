//
//  FAQViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

// MARK: - FAQViewController
final class FAQViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: FAQBusinessLogic
    private let router: FAQRoutingLogic
    private let tabBar = TabBar()
    private let questionsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: JumpAvoidingFlowLayout()
    )
    private let questions: [String] = ["question_1".localize(), "question_2".localize(), "question_3".localize()]
    private let answers: [String] = ["answer_1".localize(), "answer_2".localize(), "answer_3".localize()]
    private var cellForSize = QuestionCell()
    
    // MARK: - LifeCycle
    init(
        router: FAQRoutingLogic,
        interactor: FAQBusinessLogic
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
        configureTabBar()
        configureQuestionsCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.active.uiColor
        navigationItem.title = "FAQ".localize()
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
        tabBar.setMoreButtonActive()
    }
    
    private func configureQuestionsCollectionView() {
        self.view.addSubview(questionsCollectionView)
        questionsCollectionView.pinLeft(to: self.view.leadingAnchor)
        questionsCollectionView.pinRight(to: self.view.trailingAnchor)
        questionsCollectionView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        questionsCollectionView.pinBottom(to: self.tabBar.topAnchor)
        questionsCollectionView.dataSource = self
        questionsCollectionView.delegate = self
        questionsCollectionView.backgroundColor = .clear
        questionsCollectionView.showsVerticalScrollIndicator = false
        questionsCollectionView.allowsMultipleSelection = true
        questionsCollectionView.register(QuestionCell.self, forCellWithReuseIdentifier: "QuestionCell")
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.interactor.loadMore(Model.More.Request())
    }
}

// MARK: - DisplayLogic
extension FAQViewController: FAQDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayHome(_ viewModel: Model.Home.ViewModel) {
        self.router.routeToHome()
    }
    
    func displayMore(_ viewModel: Model.More.ViewModel) {
        self.router.routeToMore()
    }
}

// MARK: - CollectionView
extension FAQViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as? QuestionCell else {
            return UICollectionViewCell()
        }
        cell.configure(question: self.questions[indexPath.row], answer: self.answers[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false

        cellForSize.configure(question: self.questions[indexPath.row], answer: self.answers[indexPath.row])

        cellForSize.frame = CGRect(
            origin: .zero,
            size: CGSize(width: collectionView.bounds.width - 34, height: 1000)
        )

        cellForSize.isSelected = isSelected
        cellForSize.setNeedsLayout()
        cellForSize.layoutIfNeeded()
        let size = cellForSize.systemLayoutSizeFitting(
            CGSize(width: collectionView.bounds.width - 34, height: .greatestFiniteMagnitude),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 35, left: 17, bottom: 120, right: 17)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        
        DispatchQueue.main.async {
            guard let attributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
                return
            }
            let desiredOffset = attributes.frame.origin.y - 35
            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            let maxPossibleOffset = contentHeight - collectionView.bounds.height
            let finalOffset = max(min(desiredOffset, maxPossibleOffset), 0)
            collectionView.setContentOffset(
                CGPoint(x: 0, y: finalOffset),
                animated: true
            )
        }
        return true
    }
}
