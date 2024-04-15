//
//  ParkingSpotsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

import Foundation

struct ParkingSpot: Decodable {
    let id: String
    let levelId: String
    let buildingId: String
    let parkingNumber: String
    let isAvailable: Bool
    let isFree: Bool
    let canvas: Canvas
    let onCanvasCoords: OnCanvasCoords
}
