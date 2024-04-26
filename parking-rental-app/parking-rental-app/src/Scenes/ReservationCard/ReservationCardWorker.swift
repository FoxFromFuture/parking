//
//  ReservationCardWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

import UIKit

final class ReservationCardWorker {
    // MARK: - Private Properties
    let networkManager = NetworkManager()
}

// MARK: - WorkerLogic
extension ReservationCardWorker: ReservationCardWorkerLogic {
    func getParkingSpot(parkingSpotID: String, completion: @escaping (_ parkingSpotData: ParkingSpot?, _ error: String?) -> ()) {
        networkManager.getParkingSpot(parkingSpotID: parkingSpotID) { parkingSpotData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = parkingSpotData {
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
    
    func getAllCars(completion: @escaping (_ carsData: [Car]?, _ error: String?) -> ()) {
        networkManager.getAllCars { carsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = carsData {
                completion(data, nil)
            }
        }
    }
    
    func getCar(carID: String, completion: @escaping (_ carData: Car?, _ error: String?) -> ()) {
        networkManager.getCar(carID: carID) { carData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = carData {
                completion(data, nil)
            }
        }
    }
    
    func addNewReservation(carId: String, employeeId: String, parkingSpotId: String, startTime: String, endTime: String, completion: @escaping (_ reservationData: Reservation?, _ error: String?) -> ()) {
        networkManager.addNewReservation(carId: carId, employeeId: employeeId, parkingSpotId: parkingSpotId, startTime: startTime, endTime: endTime) { reservationData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = reservationData {
                completion(data, nil)
            }
        }
    }
    
    func deleteReservation(id: String, completion: @escaping (_ error: String?) -> ()) {
        networkManager.deleteReservation(id: id) { error in
            completion(error)
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
    
    
}
