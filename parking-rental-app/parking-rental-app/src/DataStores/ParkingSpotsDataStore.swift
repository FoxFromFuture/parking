//
//  ParkingSpotsDataStore.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

final class ParkingSpotsDataStore {
    
    static let shared = ParkingSpotsDataStore()
    var parkingSpots: [ParkingSpot]?
    var parkingSpotForMapID: String?
    
    private init() { }
}
