//
//  OnboardingAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/1/24.
//

import UIKit

enum OnboardingAssembly {
    static func build() -> UIViewController {
        let router: OnboardingRouter = OnboardingRouter()
        let presenter: OnboardingPresenter = OnboardingPresenter()
        let interactor: OnboardingInteractor = OnboardingInteractor(presenter: presenter)
        let viewController: OnboardingViewController = OnboardingViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
