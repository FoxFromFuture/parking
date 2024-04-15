//
//  LoginModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

enum LoginModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Home {
        struct Request {
            let email: String
            let password: String
        }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Registration {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum LoginFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
