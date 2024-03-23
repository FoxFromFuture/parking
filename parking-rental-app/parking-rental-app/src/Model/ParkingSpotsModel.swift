//
//  ParkingSpotsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

import Foundation

struct ParkingSpot {
    let id: String
    let levelId: String
    let buildingId: String
    let parkingNumber: String
    let isAvailable: Bool
    let isFree: Bool
    let canvas: Canvas
    let onCanvasCoords: OnCanvasCoords
}

extension ParkingSpot: Decodable {
    enum ParkingSpotCodingKeys: String, CodingKey {
        case id
        case levelId
        case buildingId
        case parkingNumber
        case isAvailable
        case isFree
        case canvas
        case onCanvasCoords
    }

    init(from decoder: Decoder) throws {
        let parkingSpotContainer = try decoder.container(keyedBy: ParkingSpotCodingKeys.self)
        id = try parkingSpotContainer.decode(String.self, forKey: .id)
        levelId = try parkingSpotContainer.decode(String.self, forKey: .levelId)
        buildingId = try parkingSpotContainer.decode(String.self, forKey: .buildingId)
        parkingNumber = try parkingSpotContainer.decode(String.self, forKey: .parkingNumber)
        isAvailable = try parkingSpotContainer.decode(Bool.self, forKey: .isAvailable)
        isFree = try parkingSpotContainer.decode(Bool.self, forKey: .isFree)
        canvas = try parkingSpotContainer.decode(Canvas.self, forKey: .canvas)
        onCanvasCoords = try parkingSpotContainer.decode(OnCanvasCoords.self, forKey: .onCanvasCoords)
    }
}
