//
//  CarsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/20/24.
//

import Foundation

struct CarsApiResponse: Decodable {
    let cars: [Car]
}

struct Car: Decodable {
    let id: String
    let ownerId: String
    let model: String
    let lengthMeters: Double
    let weightTons: Double
    let registryNumber: String
}
