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
    func routeToAccountCars() {
        view?.navigationController?.popViewController(animated: true)
    }
}
