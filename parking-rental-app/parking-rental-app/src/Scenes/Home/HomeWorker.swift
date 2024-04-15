//
//  HomeWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class HomeWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager()
}

// MARK: - WorkerLogic
extension HomeWorker: HomeWorkerLogic {
    func getAllReservations(completion: @escaping ([Reservation]?, String?) -> ()) {
        networkManager.getAllReservations { reservationsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = reservationsData {
                completion(data, nil)
            }
        }
    }
    
    func getAllParkingSpots(completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: String?) -> ()) {
        networkManager.getAllParkingSpots { parkingSpotsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingSpotsData {
                completion(data, nil)
            }
        }
    }
    
    func getAllParkingLevels(completion: @escaping (_ parkingLevelsData: [ParkingLevel]?, _ error: String?) -> ()) {
        networkManager.getAllParkingLevels { parkingLevelsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingLevelsData {
                completion(data, nil)
            }
        }
    }
    
    func getAllBuildings(completion: @escaping (_ buildingsData: [Building]?, _ error: String?) -> ()) {
        networkManager.getAllBuildings { buildingsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = buildingsData {
                completion(data, nil)
            }
        }
    }
}
