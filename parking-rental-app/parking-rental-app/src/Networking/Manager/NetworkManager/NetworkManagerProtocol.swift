//
//  NetworkManagerProtocol.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/17/24.
//

import Foundation

enum NetworkResponse: String {
    case success
    case connectionFailure = "Please check your network connection."
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request."
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case noResponse = "No response."
    case getTokenFailure = "Get Token Error."
    case updateTokenFailure = "Update Token Error."
    case noRefreshToken = "Refresh token doesn't exist."
}

protocol NetworkManagerProtocol {
    // MARK: - Auth API
    func login(email: String, password: String, completion: @escaping (_ authData: AuthApiResponse?, _ error: NetworkResponse?) -> ())
    
    func signup(name: String, email: String, password: String, completion: @escaping (_ authData: AuthApiResponse?, _ error: NetworkResponse?) -> ())
    
    func whoami(completion: @escaping (_ authData: AuthWhoamiApiResponse?, _ error: NetworkResponse?) -> ())
    
    // MARK: - Reservations API
    func getAllReservations(completion: @escaping (_ reservationsData: [Reservation]?, _ error: NetworkResponse?) -> ())
    
    func getReservation(reservationID: String, completion: @escaping (_ reservationData: Reservation?, _ error: NetworkResponse?) -> ())
    
    func addNewReservation(carId: String, employeeId: String, parkingSpotId: String, startTime: String, endTime: String, completion: @escaping (_ reservationData: Reservation?, _ error: NetworkResponse?) -> ())
    
    func deleteReservation(id: String, completion: @escaping (_ error: NetworkResponse?) -> ())
    
    // MARK: - ParkingSpots API
    func getAllParkingSpots(completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: NetworkResponse?) -> ())
    
    func getParkingSpot(parkingSpotID: String, completion: @escaping (_ parkingSpotData: ParkingSpot?, _ error: NetworkResponse?) -> ())
    
    // MARK: - ParkingLevels API
    func getAllParkingLevels(completion: @escaping (_ parkingLevelsData: [ParkingLevel]?, _ error: NetworkResponse?) -> ())
    
    func getAllLevelSpots(parkingLevelID: String, completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: NetworkResponse?) -> ())
    
    func getParkingLevel(parkingLevelID: String, completion: @escaping (_ parkingLevelData: ParkingLevel?, _ error: NetworkResponse?) -> ())
    
    func getAllLevelFreeSpots(parkingLevelID: String, startTime: String, endTime: String, completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: NetworkResponse?) -> ())
    
    // MARK: - Buildings API
    func getAllBuildings(completion: @escaping (_ buildingsData: [Building]?, _ error: NetworkResponse?) -> ())
    
    func getAllBuildingLevels(buildingID: String, completion: @escaping (_ levelsData: [ParkingLevel]?, _ error: NetworkResponse?) -> ())
    
    func getBuilding(buildingID: String, completion: @escaping (_ buildingData: Building?, _ error: NetworkResponse?) -> ())
    
    // MARK: - Cars API
    func addNewCar(model: String, registryNumber: String, completion: @escaping (_ carData: Car?, _ error: NetworkResponse?) -> ())
    
    func updateCar(id: String, model: String, registryNumber: String, completion: @escaping (_ carData: Car?, _ error: NetworkResponse?) -> ())
    
    func getAllCars(completion: @escaping (_ carsData: [Car]?, _ error: NetworkResponse?) -> ())
    
    func getCar(carID: String, completion: @escaping (_ carData: Car?, _ error: NetworkResponse?) -> ())
    
    func deleteCar(carID: String, completion: @escaping (_ error: NetworkResponse?) -> ())
    
    // MARK: - Employees API
    func deleteEmployee(completion: @escaping (_ error: NetworkResponse?) -> ())
    
    func updateEmployee(name: String, email: String, password: String, completion: @escaping (_ authData: AuthApiResponse?, _ error: NetworkResponse?) -> ())
}
