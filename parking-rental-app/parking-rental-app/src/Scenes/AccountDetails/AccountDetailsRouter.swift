//
//  AccountDetailsRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

final class AccountDetailsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension AccountDetailsRouter: AccountDetailsRoutingLogic {
    func routeToProfile() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToLogin() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("could not get scene delegate ")
        }
        sceneDelegate.navigationController.pushViewController(NotAuthTabBarController(), animated: false)
    }
    
    func routeToUpdateAccount() {
        view?.navigationController?.pushViewController(UpdateAccountAssembly.build(), animated: true)
    }
}
