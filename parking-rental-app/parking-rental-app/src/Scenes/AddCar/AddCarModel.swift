//
//  AddCarModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit

enum AddCarModel {
    
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
    
    enum AccountCars {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum AddCarRequest {
        struct Request {
            let model: String
            let registryNumber: String
        }
        struct Response { }
        struct ViewModel { }
    }
    
    enum AddCarFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
