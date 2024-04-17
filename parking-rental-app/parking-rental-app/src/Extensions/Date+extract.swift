//
//  Date+extract.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/16/24.
//

import Foundation

extension Date {
    func extractDate() -> String {
        return "\("\(self)".prefix(10))"
    }
}
