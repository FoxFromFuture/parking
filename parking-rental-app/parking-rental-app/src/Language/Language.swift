//
//  Language.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/8/24.
//

enum Language: String {
    case en
    case ru
    
    var expandedStr: String {
        switch self {
        case .en:
            return "english".localize()
        case .ru:
            return "russian".localize()
        }
    }
}
