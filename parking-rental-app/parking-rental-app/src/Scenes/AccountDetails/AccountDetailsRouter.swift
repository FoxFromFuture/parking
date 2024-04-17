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
    
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: false)
    }
    
    func routeToLogin() {
        view?.navigationController?.pushViewController(LoginAssembly.build(), animated: false)
    }
    
    func routeToUpdateAccount() {
        view?.navigationController?.pushViewController(UpdateAccountAssembly.build(), animated: true)
    }
}
