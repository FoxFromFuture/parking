//
//  BuildingsModel.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

enum BuildingsModel {
    
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    enum GetBuildings {
        struct Request { }
        struct Response {
            let buildings: [Building]
        }
        struct ViewModel {
            let buildingsCount: Int
            let buildingNames: [String]
            let buildingAddresses: [String]
            let buildingsIDx: [String]
        }
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
    
    enum Map {
        struct Request {
            let buildingID: String
        }
        struct Response {
            let buildingID: String
        }
        struct ViewModel {
            let buildingID: String
        }
        struct RouteData {
            let buildingID: String
        }
    }
    
    enum LoadingFailure {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
