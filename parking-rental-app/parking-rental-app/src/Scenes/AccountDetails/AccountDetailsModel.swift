//
//  AccountDetailsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

enum AccountDetailsModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Profile {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum UserDetails {
        struct Request { }
        struct Response {
            let user: AuthWhoamiApiResponse
        }
        struct ViewModel {
            let name: String
            let email: String
        }
    }
    
    enum Login {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum UpdateAccount {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum UpdateAccountFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
