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
        view?.navigationController?.pushViewController(LoginAssembly.build(), animated: true)
    }
    
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: true)
    }
}
