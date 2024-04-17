//
//  Date+iso8601.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/16/24.
//

import Foundation

extension Date {
    func getISO8601Str() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = .current
        
        return "\(isoFormatter.string(from: self).prefix(19))"
    }
}
