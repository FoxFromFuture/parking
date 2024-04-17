//
//  UpdateAccountRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

final class UpdateAccountRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension UpdateAccountRouter: UpdateAccountRoutingLogic {
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: false)
    }
    
    func routeToAccountDetails() {
        view?.navigationController?.popViewController(animated: true)
    }
}
