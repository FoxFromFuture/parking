//
//  BuildingModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

struct Building {
    let id: String
    let name: String
    let address: String
    let numberOfLevels: Int
}

extension Building: Decodable {
    enum BuildingCodingKeys: String, CodingKey {
        case id
        case name
        case address
        case numberOfLevels
    }

    init(from decoder: Decoder) throws {
        let buildingContainer = try decoder.container(keyedBy: BuildingCodingKeys.self)
        id = try buildingContainer.decode(String.self, forKey: .id)
        name = try buildingContainer.decode(String.self, forKey: .name)
        address = try buildingContainer.decode(String.self, forKey: .address)
        numberOfLevels = try buildingContainer.decode(Int.self, forKey: .numberOfLevels)
    }
}
