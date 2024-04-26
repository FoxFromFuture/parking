//
//  AccountCarsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

import UIKit

enum AccountCarsModel {
    
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
    
    enum Profile {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum AccountCarsRequest {
        struct Request { }
        struct Response {
            let isLimit: Bool
            let cars: [Car]
        }
        struct ViewModel {
            let isLimit: Bool
            let cars: [Car]
        }
    }
    
    enum AccountCarsFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum CarDetails {
        struct Request {
            let carID: String
        }
        struct Response {
            let carID: String
        }
        struct ViewModel {
            let carID: String
        }
        struct RouteData {
            let carID: String
        }
    }
    
    enum AddCar {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
