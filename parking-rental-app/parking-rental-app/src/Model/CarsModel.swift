//
//  CarsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/20/24.
//

import Foundation

struct CarsApiResponse {
    let cars: [Car]
}

extension CarsApiResponse: Decodable {
    init(from decoder: Decoder) throws {
        var carsContainer = try decoder.unkeyedContainer()
        cars = try carsContainer.decode([Car].self)
    }
}

struct Car {
    let id: String
    let ownerId: String
    let model: String
    let lengthMeters: Double
    let weightTons: Double
    let registryNumber: String
}

extension Car: Decodable {
    enum CarCodingKeys: String, CodingKey {
        case id
        case ownerId
        case model
        case lengthMeters
        case weightTons
        case registryNumber
    }
    
    init(from decoder: Decoder) throws {
        let carContainer = try decoder.container(keyedBy: CarCodingKeys.self)
        id = try carContainer.decode(String.self, forKey: .id)
        ownerId = try carContainer.decode(String.self, forKey: .ownerId)
        model = try carContainer.decode(String.self, forKey: .model)
        lengthMeters = try carContainer.decode(Double.self, forKey: .lengthMeters)
        weightTons = try carContainer.decode(Double.self, forKey: .weightTons)
        registryNumber = try carContainer.decode(String.self, forKey: .registryNumber)
    }
}
