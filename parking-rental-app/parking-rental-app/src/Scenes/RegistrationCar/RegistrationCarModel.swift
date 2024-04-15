//
//  RegistrationCarModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

enum RegistrationCarModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Home {
        struct Request {
            let carRegistryNumber: String
        }
        struct Response { }
        struct ViewModel { }
    }
    
    enum CarSetupFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
