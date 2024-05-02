//
//  SplashRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import UIKit

final class SplashRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension SplashRouter: SplashRoutingLogic {
    func routeToLogin() {
        view?.navigationController?.pushViewController(NotAuthTabBarController(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.pushViewController(TabBarController(), animated: false)
    }
}
