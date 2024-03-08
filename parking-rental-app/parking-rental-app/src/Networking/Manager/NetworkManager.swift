//
//  NetworkManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/20/24.
//

import Foundation

enum NetworkEnvironment {
    case production
}

final class NetworkManager {
    static let shared = NetworkManager()
    static let environment: NetworkEnvironment = .production
    private let authManager = AuthManager.shared
    private let carsRouter = Router<CarsApi>()
    private let authRouter = Router<AuthApi>()
    private let reservationsRouter = Router<ReservationsApi>()
    private let parkingSpotsRouter = Router<ParkingSpotsApi>()
    
    private init() { }
    
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
    
    private func responseDecoder<T: Decodable>(data: Data?, dataType: T.Type, response: URLResponse?, error: Error?) -> (data: T?, error: String?) {
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
        }
        return (nil, nil)
    }
    
    func authRequest<TRouter: NetworkRouter, TResponse: Decodable>(router: TRouter, task: TRouter.EndPoint, responseType: TResponse.Type, completion: @escaping (_ data: TResponse?, _ error: String?) -> ()) {
        router.request(task) { [weak self] data, response, error in
            let responseDecoder = self?.responseDecoder(data: data, dataType: responseType, response: response, error: error)
            if responseDecoder?.error == nil {
                completion(responseDecoder?.data as? TResponse, nil)
            }
            if responseDecoder?.error == NetworkResponse.authenticationError.rawValue {
                self?.updateAccessToken(completion: { [weak self] authData, error in
                    // RETURN NORMAL ERROR FROM UPDATEACCESSTOKEN FUNC, NOT JUST RETURN MOTHERFUCKER
                    if error != nil {
                        completion(nil, responseDecoder?.error)
                    } else {
                        guard let newRefreshToken = authData?.accessToken else {
                            completion(nil, "Get Token Error")
                            return
                        }
                        if !(self?.authManager.updateToken(token: newRefreshToken, tokenType: .refresh) ?? true) {
                            completion(nil, "Update Token Error")
                        }
                        router.request(task) { [weak self] data, response, error in
                            let responseDecoder = self?.responseDecoder(data: data, dataType: responseType, response: response, error: error)
                            completion(responseDecoder?.data as? TResponse, responseDecoder?.error)
                        }
                    }
                })
            } else {
                completion(nil, responseDecoder?.error)
            }
        }
    }
    
    // MARK: - Tokens Processing
    private func updateRefreshToken(completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ()) {
        guard let oldRefreshToken = authManager.getRefreshToken() else {
            return
        }
        authRouter.request(.updateRefreshToken(refreshToken: oldRefreshToken)) { [weak self] data, response, error in
            let responseDecoder = self?.responseDecoder(data: data, dataType: AuthApiResponse.self, response: response, error: error)
            completion(responseDecoder?.data as? AuthApiResponse, responseDecoder?.error)
        }
    }
    
    private func updateAccessToken(completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ()) {
        guard let refreshToken = authManager.getRefreshToken() else {
            return
        }
        authRouter.request(.updateAccessToken(refreshToken: refreshToken)) { [weak self] data, response, error in
            let responseDecoder = self?.responseDecoder(data: data, dataType: AuthApiResponse.self, response: response, error: error)
            if responseDecoder?.error == nil {
                completion(responseDecoder?.data as? AuthApiResponse, nil)
            }
            if responseDecoder?.error == NetworkResponse.authenticationError.rawValue {
                self?.updateRefreshToken(completion: { [weak self] authData, error in
                    if error != nil {
                        return
                    } else {
                        guard let newRefreshToken = authData?.refreshToken else { return }
                        if !(self?.authManager.updateToken(token: newRefreshToken, tokenType: .refresh) ?? true) {
                            return
                        }
                        self?.authRouter.request(.updateAccessToken(refreshToken: refreshToken)) { [weak self] data, response, error in
                            let responseDecoder = self?.responseDecoder(data: data, dataType: AuthApiResponse.self, response: response, error: error)
                            completion(responseDecoder?.data as? AuthApiResponse, responseDecoder?.error)
                        }
                    }
                })
            } else {
                completion(nil, responseDecoder?.error)
            }
        }
    }
    
    // MARK: - Auth API
    func login(email: String, password: String, completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ()) {
        authRouter.request(.login(email: email, password: password)) { [weak self] data, response, error in
            let responseDecoder = self?.responseDecoder(data: data, dataType: AuthApiResponse.self, response: response, error: error)
            completion(responseDecoder?.data as? AuthApiResponse, responseDecoder?.error)
        }
    }
    
    func signup(name: String, email: String, password: String, completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ()) {
        authRouter.request(.signUp(name: name, email: email, password: password)) { [weak self] data, response, error in
            let responseDecoder = self?.responseDecoder(data: data, dataType: AuthApiResponse.self, response: response, error: error)
            completion(responseDecoder?.data as? AuthApiResponse, responseDecoder?.error)
        }
    }
    
    /// TODO: rewrite with generic func usage
    func whoami(completion: @escaping (_ authData: AuthWhoamiApiResponse?, _ error: String?) -> ()) {
        authRouter.request(.whoami) { [weak self] data, response, error in
            let responseDecoder = self?.responseDecoder(data: data, dataType: AuthWhoamiApiResponse.self, response: response, error: error)
            if responseDecoder?.error == NetworkResponse.authenticationError.rawValue {
                self?.updateAccessToken(completion: { [weak self] authData, error in
                    if error != nil {
                        return
                    } else {
                        guard let newRefreshToken = authData?.accessToken else { return }
                        if !(self?.authManager.updateToken(token: newRefreshToken, tokenType: .refresh) ?? true) {
                            return
                        }
                        self?.authRouter.request(.whoami) { [weak self] data, response, error in
                            let responseDecoder = self?.responseDecoder(data: data, dataType: AuthWhoamiApiResponse.self, response: response, error: error)
                            completion(responseDecoder?.data as? AuthWhoamiApiResponse, responseDecoder?.error)
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Reservations API
    func getAllReservations(completion: @escaping (_ reservationsData: [Reservation]?, _ error: String?) -> ()) {
        authRequest(router: reservationsRouter, task: .getAllReservations, responseType: [Reservation].self) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                completion(data, nil)
            }
        }
    }
    
    // MARK: - ParkingSpots API
    func getParkingSpotInfo(id: String, completion: @escaping (_ parkingSpotData: [Reservation]?, _ error: String?) -> ()) {
        authRequest(router: parkingSpotsRouter, task: .getParkingSpotInfo(id: id), responseType: <#T##Decodable.Protocol#>, completion: <#T##(Decodable?, String?) -> ()##(Decodable?, String?) -> ()##(_ data: Decodable?, _ error: String?) -> ()#>)
    }
    
    // MARK: - ParkingLevels API
    
    // MARK: - ParkingBuildings API
}
