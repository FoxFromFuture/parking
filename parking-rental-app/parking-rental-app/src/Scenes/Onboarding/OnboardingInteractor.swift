//
//  OnboardingInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/1/24.
//

import UIKit

final class OnboardingInteractor {
    // MARK: - Private Properties
    private let presenter: OnboardingPresentationLogic
    
    // MARK: - Initializers
    init(presenter: OnboardingPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension OnboardingInteractor: OnboardingBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(OnboardingModel.Home.Response())
    }
}
