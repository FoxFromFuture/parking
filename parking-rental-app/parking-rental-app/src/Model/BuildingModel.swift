//
//  BuildingModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import Foundation

struct Building: Decodable {
    let id: String
    let name: String
    let address: String
    let numberOfLevels: Int
}
