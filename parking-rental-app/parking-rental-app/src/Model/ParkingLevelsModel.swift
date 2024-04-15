//
//  ParkingLevelsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

struct ParkingLevel: Decodable {
    let id: String
    let buildingId: String
    let levelNumber: Int
    let numberOfSpots: Int
    let canvas: Canvas
}
