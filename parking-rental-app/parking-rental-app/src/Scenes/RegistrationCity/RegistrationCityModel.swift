//
//  RegistrationCityModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

enum RegistrationCityModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum RegistrationCar {
        struct Request {
            let city: String
        }
        struct Response { }
        struct ViewModel { }
    }
}
