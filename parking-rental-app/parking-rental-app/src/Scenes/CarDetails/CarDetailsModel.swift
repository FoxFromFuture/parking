//
//  CarDetailsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit

enum CarDetailsModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum CarDetails {
        struct Request {
            let carID: String
        }
        struct Response {
            let car: Car
            let isOnlyOneCarLasts: Bool
        }
        struct ViewModel {
            let model: String
            let registryNumber: String
            let isOnlyOneCarLasts: Bool
        }
    }
    
    enum CarDetailsFailure {
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
    
    enum AccountCars {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum UpdateCar {
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
    
    enum DeleteCar {
        struct Request {
            let carID: String
        }
        struct Response { }
        struct ViewModel { }
    }
}
