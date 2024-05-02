//
//  OnboardingRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/1/24.
//

import UIKit

final class OnboardingRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension OnboardingRouter: OnboardingRoutingLogic {
    func routeToHome() {
        view?.navigationController?.pushViewController(TabBarController(), animated: true)
    }
}
