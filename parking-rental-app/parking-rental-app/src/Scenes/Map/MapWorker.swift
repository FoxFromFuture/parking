//
//  MapWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MapWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager()
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
    
    func getAllLevelFreeSpots(parkingLevelID: String, startTime: String, endTime: String, completion: @escaping ([ParkingSpot]?, String?) -> ()) {
        networkManager.getAllLevelFreeSpots(parkingLevelID: parkingLevelID, startTime: startTime, endTime: endTime) { parkingSpotsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingSpotsData {
                completion(data, nil)
            }
        }
    }
    
    func getAllReservations(completion: @escaping (_ reservationsData: [Reservation]?, _ error: String?) -> ()) {
        networkManager.getAllReservations { reservationsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = reservationsData {
                completion(data, nil)
            }
        }
    }
    
    func getBuilding(buildingID: String, completion: @escaping (_ buildingData: Building?, _ error: String?) -> ()) {
        networkManager.getBuilding(buildingID: buildingID) { buildingData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = buildingData {
                completion(data, nil)
            }
        }
    }
    
    func getReservation(reservationID: String, completion: @escaping (_ reservationData: Reservation?, _ error: String?) -> ()) {
        networkManager.getReservation(reservationID: reservationID) { reservationData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = reservationData {
                completion(data, nil)
            }
        }
    }
    
    func getParkingSpot(parkingSpotID: String, completion: @escaping (_ parkingSpotData: ParkingSpot?, _ error: String?) -> ()) {
        networkManager.getParkingSpot(parkingSpotID: parkingSpotID) { parkingSpotData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingSpotData {
                completion(data, nil)
            }
        }
    }
    
    func getParkingLevel(parkingLevelID: String, completion: @escaping (_ parkingLevelData: ParkingLevel?, _ error: String?) -> ()) {
        networkManager.getParkingLevel(parkingLevelID: parkingLevelID) { parkingLevelData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingLevelData {
                completion(data, nil)
            }
        }
    }
}
