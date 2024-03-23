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
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToUpdateCar() {
        view?.navigationController?.pushViewController(UpdateCarAssembly.build(), animated: true)
    }
    
    func routeToLogin() {
        view?.navigationController?.pushViewController(LoginAssembly.build(), animated: false)
    }
}
