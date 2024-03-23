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
    
    func getParkingSpotsInfo(id: String, completion: @escaping (_ parkingSpotInfo: ParkingSpot?, _ error: String?) -> ()) {
        networkManager.getParkingSpotInfo(id: UUID(uuidString: id) ?? UUID()) { parkingSpotData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingSpotData {
                completion(data, nil)
            }
        }
    }
    
    func getParkingSpots(completion: @escaping ([ParkingSpot]?, String?) -> ()) {
        networkManager.getAllParkingSpots { parkingSpotsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingSpotsData {
                completion(data, nil)
            }
        }
    }
    
    func getAllParkingLevels(completion: @escaping ([ParkingLevel]?, String?) -> ()) {
        networkManager.getAllParkingLevels { parkingLevelsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingLevelsData {
                completion(data, nil)
            }
        }
    }
    
    func getAllBuildings(completion: @escaping ([Building]?, String?) -> ()) {
        networkManager.getAllBuildings { buildingsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = buildingsData {
                completion(data, nil)
            }
        }
    }
}
