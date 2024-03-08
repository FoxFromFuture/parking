//
//  HomeWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class HomeWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
}

// MARK: - WorkerLogic
extension HomeWorker: HomeWorkerLogic {
    func getReservations(completion: @escaping ([Reservation]?, String?) -> ()) {
        networkManager.getAllReservations { reservationsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = reservationsData {
                completion(data, nil)
            }
        }
    }
}
