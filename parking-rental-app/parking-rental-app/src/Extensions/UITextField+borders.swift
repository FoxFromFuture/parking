//
//  UITextField+borders.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/11/24.
//

import UIKit

extension UITextField {
    func addBottomBorder(color: UIColor, thickness: CGFloat) -> UIView {
        let bottomBorder = UIView()
        bottomBorder.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        bottomBorder.backgroundColor = color
        self.addSubview(bottomBorder)
        bottomBorder.pinTop(to: self.bottomAnchor, 15)
        bottomBorder.pinLeft(to: self.leadingAnchor)
        bottomBorder.pinRight(to: self.trailingAnchor)
        bottomBorder.setHeight(thickness)
        return bottomBorder
    }
}
