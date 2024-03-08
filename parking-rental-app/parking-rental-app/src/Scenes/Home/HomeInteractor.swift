//
//  HomeInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class HomeInteractor {
    // MARK: - Private Properties
    private let presenter: HomePresentationLogic
    private let worker: HomeWorkerLogic
    private let reservationsDataStore = ReservationsDataStore.shared
    
    // MARK: - Initializers
    init(presenter: HomePresentationLogic, worker: HomeWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadReservations(_ request: Model.GetReservations.Request) {
        worker.getReservations() { [weak self] reservationsData, error in
            if let error = error {
                print(error)
                /// TODO: Present failure
            } else if let data = reservationsData {
                self?.reservationsDataStore.reservations = data
                self?.presenter.presentReservations(Model.GetReservations.Response())
            }
        }
    }
}
