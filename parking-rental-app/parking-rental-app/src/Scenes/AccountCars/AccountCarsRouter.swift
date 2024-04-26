//
//  AccountCarsRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

import UIKit

final class AccountCarsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension AccountCarsRouter: AccountCarsRoutingLogic {
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: false)
    }
    
    func routeToProfile() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToCarDetails(_ routeData: Model.CarDetails.RouteData) {
        view?.navigationController?.pushViewController(CarDetailsAssembly.build(carID: routeData.carID), animated: true)
    }
    
    func routeToAddCar() {
        view?.navigationController?.pushViewController(AddCarAssembly.build(), animated: true)
    }
}
