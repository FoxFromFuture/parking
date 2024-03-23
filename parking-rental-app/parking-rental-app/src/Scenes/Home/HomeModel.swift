//
//  HomeModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

enum HomeModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum GetReservations {
        struct Request { }
        struct Response {
            let spotNumbers: [String]?
            let levelNumbers: [String]?
            let buildingNames: [String]?
        }
        struct ViewModel {
            let spotNumbers: [String]?
            let levelNumbers: [String]?
            let buildingNames: [String]?
        }
    }
    
    enum Buildings {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum Map {
        struct Request {
            let lotID: String
        }
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
}
