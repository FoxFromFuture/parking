//
//  ParkingLevelsDataStore.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

final class ParkingLevelsDataStore {
    
    static let shared = ParkingLevelsDataStore()
    var parkingLevels: [ParkingLevel]?
    
    private init() { }
}
