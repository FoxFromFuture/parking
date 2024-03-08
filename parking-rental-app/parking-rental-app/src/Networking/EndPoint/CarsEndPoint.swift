//
//  CarsEndPoint.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/20/24.
//

import Foundation

public enum CarsApi {
    case getAllCars
    case addNewCar(parameters: Parameters)
    case updateCar(id: String, parameters: Parameters)
    case deleteCar(id: String)
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
        case .getAllCars:
            return "employee"
        case .addNewCar:
            return "employee"
        case .updateCar(let id, _):
            return "\(id)/employee"
        case .deleteCar(let id):
            return "\(id)/employee"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
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
        case .getAllCars:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        case .addNewCar(let parameters):
            return .requestParametersAndHeaders(bodyParameters: parameters, urlParameters: nil, additionHeaders: self.headers)
        case .updateCar(_, let parameters):
            return .requestParametersAndHeaders(bodyParameters: parameters, urlParameters: nil, additionHeaders: self.headers)
        case .deleteCar:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionHeaders: self.headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer \(AuthManager.shared.getAccessToken() ?? "")"]
    }
}
