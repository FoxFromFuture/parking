//
//  HomeRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class HomeRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension HomeRouter: HomeRoutingLogic {
    func routeToBuildings() {
        view?.navigationController?.pushViewController(BuildingsAssembly.build(), animated: true)
    }
    
    func routeToMap(_ routeData: Model.Map.RouteData) {
        view?.navigationController?.pushViewController(MapAssembly.build(reservationID: routeData.reservationID, buildingID: nil), animated: true)
    }
    
    func routeToProfile() {
        view?.navigationController?.pushViewController(ProfileAssembly.build(), animated: true)
    }
    
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
}
