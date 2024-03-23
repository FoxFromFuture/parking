//
//  OnCanvasCoordsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

import Foundation

struct OnCanvasCoords {
    let x: Int
    let y: Int
}

extension OnCanvasCoords: Decodable {
    enum OnCanvasCoordsCodingKeys: String, CodingKey {
        case x
        case y
    }
    
    init(from decoder: Decoder) throws {
        let onCanvasCoordsContainer = try decoder.container(keyedBy: OnCanvasCoordsCodingKeys.self)
        x = try onCanvasCoordsContainer.decode(Int.self, forKey: .x)
        y = try onCanvasCoordsContainer.decode(Int.self, forKey: .y)
    }
}
