//
//  MapWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MapWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
}

// MARK: - WorkerLogic
extension MapWorker: MapWorkerLogic {
    func getAllBuildingLevels(buildingID: String, completion: @escaping ([ParkingLevel]?, String?) -> ()) {
        networkManager.getAllBuildingLevels(buildingID: buildingID) { levelsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = levelsData {
                completion(data, nil)
            }
        }
    }
    
    func getAllLevelSpots(parkingLevelID: String, completion: @escaping ([ParkingSpot]?, String?) -> ()) {
        networkManager.getAllLevelSpots(parkingLevelID: parkingLevelID) { parkingSpotsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingSpotsData {
                completion(data, nil)
            }
        }
    }
}
