//
//  ParkingLevelsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

struct ParkingLevel {
    let id: String
    let buildingId: String
    let levelNumber: Int
    let numberOfSpots: Int
    let canvas: Canvas
}

extension ParkingLevel: Decodable {
    enum ParkingLevelCodingKeys: String, CodingKey {
        case id
        case buildingId
        case levelNumber
        case numberOfSpots
        case canvas
    }

    init(from decoder: Decoder) throws {
        let parkingLevelContainer = try decoder.container(keyedBy: ParkingLevelCodingKeys.self)
        id = try parkingLevelContainer.decode(String.self, forKey: .id)
        buildingId = try parkingLevelContainer.decode(String.self, forKey: .buildingId)
        levelNumber = try parkingLevelContainer.decode(Int.self, forKey: .levelNumber)
        numberOfSpots = try parkingLevelContainer.decode(Int.self, forKey: .numberOfSpots)
        canvas = try parkingLevelContainer.decode(Canvas.self, forKey: .canvas)
    }
}
