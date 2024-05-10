//
//  ReservationCardAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

import UIKit

enum ReservationCardAssembly {
    static func build(parkingSpotID: String, date: Date, startTime: Date, endTime: Date, spotState: ReservationCardSpotState, onUpdateAction: @escaping (() -> Void)) -> UIViewController {
        let router: ReservationCardRouter = ReservationCardRouter()
        let presenter: ReservationCardPresenter = ReservationCardPresenter()
        let interactor: ReservationCardInteractor = ReservationCardInteractor(presenter: presenter)
        let viewController: ReservationCardViewController = ReservationCardViewController(
            router: router,
            interactor: interactor,
            parkingSpotID: parkingSpotID,
            date: date,
            startTime: startTime,
            endTime: endTime,
            spotState: spotState,
            onUpdateAction: onUpdateAction
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
