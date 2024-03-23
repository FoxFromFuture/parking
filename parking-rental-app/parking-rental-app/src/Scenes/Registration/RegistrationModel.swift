//
//  RegistrationModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

enum RegistrationModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum RegistrationCar {
        struct Request {
            let name: String
            let email: String
            let password: String
        }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Login {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
