//
//  String+localize.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/8/24.
//

import Foundation

extension String {
     func localize() -> String {
         let defaultLanguage = Language.en.rawValue
         let value = NSLocalizedString(self, comment: "")
         if value != self || NSLocale.preferredLanguages.first == defaultLanguage {
             return value
         }

         guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
             return value
         }

         return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
