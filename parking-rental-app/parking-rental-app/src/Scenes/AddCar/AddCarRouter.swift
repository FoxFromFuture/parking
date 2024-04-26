//
//  AddCarRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit

final class AddCarRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension AddCarRouter: AddCarRoutingLogic {
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: false)
    }
    
    func routeToAccountCars() {
        view?.navigationController?.popViewController(animated: true)
    }
}
