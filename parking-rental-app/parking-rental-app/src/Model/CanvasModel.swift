//
//  CanvasModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

import Foundation

struct Canvas {
    let width: Int
    let height: Int
}

extension Canvas: Decodable {
    enum CanvasCodingKeys: String, CodingKey {
        case width
        case height
    }

    init(from decoder: Decoder) throws {
        let canvasContainer = try decoder.container(keyedBy: CanvasCodingKeys.self)
        width = try canvasContainer.decode(Int.self, forKey: .width)
        height = try canvasContainer.decode(Int.self, forKey: .height)
    }
}
