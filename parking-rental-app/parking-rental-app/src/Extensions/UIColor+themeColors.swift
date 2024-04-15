//
//  UIColor+themeColors.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/11/24.
//

import UIKit

extension UIColor {
    var light: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .light))
    }
    
    var dark: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .dark))
    }
}
