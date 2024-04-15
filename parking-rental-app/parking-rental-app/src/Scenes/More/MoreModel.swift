//
//  MoreModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

enum MoreModel {
    
    enum Start {
        struct Request { }
        struct Response {
            let curTheme: Theme
        }
        struct ViewModel {
            let curTheme: Theme
        }
    }
    
    enum Home {
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
