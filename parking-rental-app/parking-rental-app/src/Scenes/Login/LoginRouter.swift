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
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: true)
    }
    
    func routeToRegistration() {
        view?.navigationController?.pushViewController(RegistrationAssembly.build(), animated: true)
    }
}
