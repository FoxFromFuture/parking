//
//  UpdateCarRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

final class UpdateCarRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension UpdateCarRouter: UpdateCarRoutingLogic {
    func routeToProfile() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: false)
    }
}
