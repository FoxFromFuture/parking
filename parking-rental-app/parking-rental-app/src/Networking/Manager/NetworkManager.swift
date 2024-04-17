//
//  NetworkManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/20/24.
//

import Foundation
import UIKit

enum NetworkEnvironment {
    case production
}

final class NetworkManager {
    static let environment: NetworkEnvironment = .production
    private let authManager = AuthManager()
    private let carsRouter = Router<CarsApi>()
    private let authRouter = Router<AuthApi>()
    private let reservationsRouter = Router<ReservationsApi>()
    private let parkingSpotsRouter = Router<ParkingSpotsApi>()
    private let parkingLevelsRouter = Router<ParkingLevelsApi>()
    private let buildingsRouter = Router<BuildingsApi>()
    private let emplyeesRouter = Router<EmployeesApi>()
    
    enum NetworkResponse: String {
        case success
        case authenticationError = "You need to be authenticated first."
        case badRequest = "Bad request."
        case outdated = "The url you requested is outdated."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }
    
    enum Result<String> {
        case success
        case failure(String)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...499: return .failure(NetworkResponse.authenticationError.rawValue)
        case 500...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    // MARK: - Generic Functions
    private func responseDataDecoder<T: Decodable>(data: Data?, dataType: T.Type, response: URLResponse?, error: Error?) -> (data: T?, error: String?) {
        if error != nil {
            return (nil, "Please check your network connection.")
        }
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    return (nil, NetworkResponse.noData.rawValue)
                }
                do {
                    let apiResponse = try JSONDecoder().decode(dataType, from: responseData)
                    return (apiResponse.self, nil)
                } catch {
                    return (nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                return (nil, networkFailureError)
            }
        } else {
            return (nil, "No response")
        }
    }
    
    private func responseNoDataDecoder(response: URLResponse?, error: Error?) -> (String?) {
        if error != nil {
            return "Please check your network connection."
        }
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                return nil
            case .failure(let networkFailureError):
                return networkFailureError
            }
        } else {
            return "No response"
        }
    }
    
    func authRequestDataResponse<TRouter: NetworkRouter, TResponse: Decodable>(router: TRouter, task: TRouter.EndPoint, responseType: TResponse.Type, completion: @escaping (_ data: TResponse?, _ error: String?) -> ()) {
        router.request(task) { [weak self] data, response, error in
            let responseDecoder = self?.responseDataDecoder(data: data, dataType: responseType, response: response, error: error)
            if responseDecoder?.error == nil {
                completion(responseDecoder?.data as? TResponse, nil)
            }
            if responseDecoder?.error == NetworkResponse.authenticationError.rawValue {
                self?.updateAccessToken(completion: { [weak self] authData, error in
                    if error != nil {
                        completion(nil, error)
                    } else {
                        guard let newAccessToken = authData?.accessToken else {
                            completion(nil, "Get Token Error")
                            return
                        }
                        if !(self?.authManager.updateToken(token: newAccessToken, tokenType: .access) ?? false) {
                            completion(nil, "Update Token Error")
                        }
                        router.request(task) { [weak self] data, response, error in
                            let responseDecoder = self?.responseDataDecoder(data: data, dataType: responseType, response: response, error: error)
                            completion(responseDecoder?.data as? TResponse, responseDecoder?.error)
                        }
                    }
                })
            } else {
                completion(nil, responseDecoder?.error)
            }
        }
    }
    
    func authRequestNoDataResponse<TRouter: NetworkRouter>(router: TRouter, task: TRouter.EndPoint, completion: @escaping (_ error: String?) -> ()) {
        router.request(task) { [weak self] data, response, error in
            let responseDecoder = self?.responseNoDataDecoder(response: response, error: error)
            if responseDecoder == nil {
                completion(nil)
            }
            if responseDecoder == NetworkResponse.authenticationError.rawValue {
                self?.updateAccessToken(completion: { [weak self] authData, error in
                    if error != nil {
                        completion(error)
                    } else {
                        guard let newAccessToken = authData?.accessToken else {
                            completion("Get Token Error")
                            return
                        }
                        if !(self?.authManager.updateToken(token: newAccessToken, tokenType: .access) ?? false) {
                            completion("Update Token Error")
                        }
                        router.request(task) { [weak self] data, response, error in
                            let responseDecoder = self?.responseNoDataDecoder(response: response, error: error)
                            completion(responseDecoder)
                        }
                    }
                })
            } else {
                completion(responseDecoder)
            }
        }
    }
    
    func authRequestCompletion<TResponse: Decodable>(_ data: TResponse?, _ error: String?, _ completion: @escaping (_ data: TResponse?, _ error: String?) -> ()) {
        if let error = error {
            completion(nil, error)
        } else if let data = data {
            completion(data, nil)
        }
    }
    
    func authRequestNoDataCompletion(_ error: String?, _ completion: @escaping (_ error: String?) -> ()) {
        completion(error)
    }
    
    // MARK: - Tokens Processing
    public func updateRefreshToken(completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ()) {
        guard let oldRefreshToken = self.authManager.getRefreshToken() else {
            completion(nil, "Refresh token doesn't exist.")
            return
        }
        authRequestDataResponse(router: authRouter, task: .updateRefreshToken(refreshToken: oldRefreshToken), responseType: AuthApiResponse.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    private func updateAccessToken(completion: @escaping (_ authData: AuthApiAccessTokenResponse?, _ error: String?) -> ()) {
        guard let refreshToken = self.authManager.getRefreshToken() else {
            completion(nil, "Refresh token doesn't exist.")
            return
        }
        authRouter.request(.updateAccessToken(refreshToken: refreshToken)) { [weak self] data, response, error in
            let responseDecoder = self?.responseDataDecoder(data: data, dataType: AuthApiAccessTokenResponse.self, response: response, error: error)
            completion(responseDecoder?.data as? AuthApiAccessTokenResponse, responseDecoder?.error)
        }
    }
    
    // MARK: - Auth API
    func login(email: String, password: String, completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ()) {
        authRouter.request(.login(email: email, password: password)) { [weak self] data, response, error in
            let responseDecoder = self?.responseDataDecoder(data: data, dataType: AuthApiResponse.self, response: response, error: error)
            completion(responseDecoder?.data as? AuthApiResponse, responseDecoder?.error)
        }
    }
    
    func signup(name: String, email: String, password: String, completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ()) {
        authRouter.request(.signUp(name: name, email: email, password: password)) { [weak self] data, response, error in
            let responseDecoder = self?.responseDataDecoder(data: data, dataType: AuthApiResponse.self, response: response, error: error)
            completion(responseDecoder?.data as? AuthApiResponse, responseDecoder?.error)
        }
    }
    
    func whoami(completion: @escaping (_ authData: AuthWhoamiApiResponse?, _ error: String?) -> ()) {
        authRequestDataResponse(router: authRouter, task: .whoami, responseType: AuthWhoamiApiResponse.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    // MARK: - Reservations API
    func getAllReservations(completion: @escaping (_ reservationsData: [Reservation]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: reservationsRouter, task: .getAllReservations, responseType: [Reservation].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getReservation(reservationID: String, completion: @escaping (_ reservationData: Reservation?, _ error: String?) -> ()) {
        authRequestDataResponse(router: reservationsRouter, task: .getReservation(reservationID: reservationID), responseType: Reservation.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func addNewReservation(carId: String, employeeId: String, parkingSpotId: String, startTime: String, endTime: String, completion: @escaping (_ reservationData: Reservation?, _ error: String?) -> ()) {
        authRequestDataResponse(router: reservationsRouter, task: .addNewReservation(carId: carId, employeeId: employeeId, parkingSpotId: parkingSpotId, startTime: startTime, endTime: endTime), responseType: Reservation.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func deleteReservation(id: String, completion: @escaping (_ error: String?) -> ()) {
        authRequestNoDataResponse(router: reservationsRouter, task: .deleteReservation(id: id)) { [weak self] error in
            self?.authRequestNoDataCompletion(error, completion)
        }
    }
    
    // MARK: - ParkingSpots API
    func getAllParkingSpots(completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: parkingSpotsRouter, task: .getAllParkingSpots, responseType: [ParkingSpot].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getParkingSpot(parkingSpotID: String, completion: @escaping (_ parkingSpotData: ParkingSpot?, _ error: String?) -> ()) {
        authRequestDataResponse(router: parkingSpotsRouter, task: .getParkingSpot(parkingSpotID: parkingSpotID), responseType: ParkingSpot.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    // MARK: - ParkingLevels API
    func getAllParkingLevels(completion: @escaping (_ parkingLevelsData: [ParkingLevel]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: parkingLevelsRouter, task: .getAllParkingLevels, responseType: [ParkingLevel].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getAllLevelSpots(parkingLevelID: String, completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: parkingLevelsRouter, task: .getAllLevelSpots(parkingLevelID: parkingLevelID), responseType: [ParkingSpot].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getParkingLevel(parkingLevelID: String, completion: @escaping (_ parkingLevelData: ParkingLevel?, _ error: String?) -> ()) {
        authRequestDataResponse(router: parkingLevelsRouter, task: .getParkingLevel(parkingLevelID: parkingLevelID), responseType: ParkingLevel.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getAllLevelFreeSpots(parkingLevelID: String, startTime: String, endTime: String, completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: parkingLevelsRouter, task: .getAllLevelFreeSpots(parkingLevelID: parkingLevelID, startTime: startTime, endTime: endTime), responseType: [ParkingSpot].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    // MARK: - Buildings API
    func getAllBuildings(completion: @escaping (_ buildingsData: [Building]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: buildingsRouter, task: .getAllBuildings, responseType: [Building].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getAllBuildingLevels(buildingID: String, completion: @escaping (_ levelsData: [ParkingLevel]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: buildingsRouter, task: .getAllBuildingLevels(buildingID: buildingID), responseType: [ParkingLevel].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getBuilding(buildingID: String, completion: @escaping (_ buildingData: Building?, _ error: String?) -> ()) {
        authRequestDataResponse(router: buildingsRouter, task: .getBuilding(buildingID: buildingID), responseType: Building.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    // MARK: - Cars API
    func addNewCar(registryNumber: String, completion: @escaping (_ carData: Car?, _ error: String?) -> ()) {
        authRequestDataResponse(router: carsRouter, task: .addNewCar(model: "Test", lengthMeters: 1.0, weightTons: 1.0, registryNumber: registryNumber), responseType: Car.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func updateCar(id: String, registryNumber: String, completion: @escaping (_ carData: Car?, _ error: String?) -> ()) {
        authRequestDataResponse(router: carsRouter, task: .updateCar(id: id, model: "Test", lengthMeters: 1.0, weightTons: 1.0, registryNumber: registryNumber), responseType: Car.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getAllCars(completion: @escaping (_ carsData: [Car]?, _ error: String?) -> ()) {
        authRequestDataResponse(router: carsRouter, task: .getAllCars, responseType: [Car].self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    func getCar(carID: String, completion: @escaping (_ carData: Car?, _ error: String?) -> ()) {
        authRequestDataResponse(router: carsRouter, task: .getCar(carID: carID), responseType: Car.self) { [weak self] data, error in
            self?.authRequestCompletion(data, error, completion)
        }
    }
    
    // MARK: - Employees API
    func deleteEmployee(completion: @escaping (_ error: String?) -> ()) {
        authRequestNoDataResponse(router: emplyeesRouter, task: .deleteEmployee) { [weak self] error in
            self?.authRequestNoDataCompletion(error, completion)
        }
    }
}
