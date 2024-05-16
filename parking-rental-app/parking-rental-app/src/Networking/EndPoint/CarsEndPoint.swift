//
//  CarsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/20/24.
//

import Foundation

public enum CarsApi {
    case getCar(carID: String, accessToken: String)
    case getAllCars(accessToken: String)
    case addNewCar(model: String, lengthMeters: Double, weightTons: Double, registryNumber: String, accessToken: String)
    case updateCar(id: String, model: String, lengthMeters: Double, weightTons: Double, registryNumber: String, accessToken: String)
    case deleteCar(id: String, accessToken: String)
}

extension CarsApi: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://localhost:8080/cars/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .getCar(let carID, _):
            return "\(carID)"
        case .getAllCars:
            return "employee"
        case .addNewCar:
            return "employee"
        case .updateCar(let id, _, _, _, _, _):
            return "\(id)/employee"
        case .deleteCar(let id, _):
            return "\(id)/employee"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getCar:
            return .get
        case .getAllCars:
            return .get
        case .addNewCar:
            return .post
        case .updateCar:
            return .put
        case .deleteCar:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getCar:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .getAllCars:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .addNewCar(let model, let lengthMeters, let weightTons, let registryNumber, _):
            return .requestParametersAndHeaders(bodyParameters: ["model": model, "lengthMeters": lengthMeters, "weightTons": weightTons, "registryNumber": registryNumber], urlParameters: nil, additionHeaders: self.headers)
        case .updateCar(_, let model, let lengthMeters, let weightTons, let registryNumber, _):
            return .requestParametersAndHeaders(bodyParameters: ["model": model, "lengthMeters": lengthMeters, "weightTons": weightTons, "registryNumber": registryNumber], urlParameters: nil, additionHeaders: self.headers)
        case .deleteCar:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getCar(_, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .getAllCars(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .addNewCar(_, _, _, _, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .updateCar(_, _, _, _, _, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        case .deleteCar(_, let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }
}
