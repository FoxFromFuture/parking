//
//  LoginRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

final class LoginRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension LoginRouter: LoginRoutingLogic {
    func routeToHome() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("could not get scene delegate ")
        }
        sceneDelegate.navigationController.pushViewController(TabBarController(), animated: false)
    }
    
    func routeToRegistration() {
        view?.navigationController?.pushViewController(RegistrationAssembly.build(), animated: true)
    }
}
