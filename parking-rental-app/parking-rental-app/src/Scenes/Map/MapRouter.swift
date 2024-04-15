//
//  MapRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MapRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension MapRouter: MapRoutingLogic {
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: false)
    }
    
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToPreviousScene() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToReservationCard(_ routeData: Model.ReservationCard.RouteData) {
        let vc = ReservationCardAssembly.build(parkingSpotID: routeData.parkingSpotID, date: routeData.date, startTime: routeData.startTime, endTime: routeData.endTime, spotState: routeData.spotState, onUpdateAction: routeData.onUpdateAction)
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        view?.navigationController?.present(vc, animated: true)
    }
}
