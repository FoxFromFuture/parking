//
//  NotAuthSettingsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

enum NotAuthSettingsModel {
    
    enum Start {
        struct Request { }
        struct Response {
            let curTheme: Theme
        }
        struct ViewModel {
            let curTheme: Theme
        }
    }
    
    enum NotAuthMore {
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
