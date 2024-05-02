//
//  ProfileRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class ProfileRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension ProfileRouter: ProfileRoutingLogic {
    func routeToHome() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToAccountCars() {
        view?.navigationController?.pushViewController(AccountCarsAssembly.build(), animated: true)
    }
    
    func routeToLogin() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("could not get scene delegate ")
        }
        sceneDelegate.navigationController.pushViewController(NotAuthTabBarController(), animated: false)
    }
    
    func routeToAccountDetails() {
        view?.navigationController?.pushViewController(AccountDetailsAssembly.build(), animated: true)
    }
}
