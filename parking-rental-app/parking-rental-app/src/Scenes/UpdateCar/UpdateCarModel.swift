//
//  UpdateCarModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

enum UpdateCarModel {
    
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
    
    enum UpdateCarRequest {
        struct Request {
            let carID: String
            let newModel: String
            let newRegistryNumber: String
        }
        struct Response { }
        struct ViewModel { }
    }
    
    enum CarUpdateFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
