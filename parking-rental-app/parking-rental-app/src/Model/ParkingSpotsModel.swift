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
        case
    }
    
    init(from decoder: Decoder) throws {
        let parkingSpotContainer = try decoder.container(keyedBy: ParkingSpotCodingKeys.self)
        id = try parkingSpotContainer.decode(String.self, forKey: .id)
        
    }
}
