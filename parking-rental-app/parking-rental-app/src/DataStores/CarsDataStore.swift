//
//  CarsDataStore.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/22/24.
//

final class CarsDataStore {
    
    static let shared = CarsDataStore()
    var cars: [Car]?
    
    private init() { }
}
