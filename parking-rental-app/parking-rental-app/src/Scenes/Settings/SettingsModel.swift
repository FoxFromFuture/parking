//
//  SettingsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

enum SettingsModel {
    
    enum Start {
        struct Request { }
        struct Response {
            let curTheme: Theme
        }
        struct ViewModel {
            let curTheme: Theme
        }
    }
    
    enum More {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum NewTheme {
        struct Request {
            let theme: Theme
        }
        struct Response {
            let theme: Theme
        }
        struct ViewModel {
            let theme: Theme
        }
    }
}
