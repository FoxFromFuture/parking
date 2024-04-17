//
//  UpdateAccountModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

enum UpdateAccountModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum More {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Home {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum AccountDetails {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum UpdateAccountRequest {
        struct Request {
            let name: String
            let email: String
            let password: String
        }
        struct Response { }
        struct ViewModel { }
    }
    
    enum UpdateAccountFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
