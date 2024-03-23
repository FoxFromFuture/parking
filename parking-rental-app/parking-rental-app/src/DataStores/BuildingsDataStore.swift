//
//  BuildingsDataStore.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

final class BuildingsDataStore {
    
    static let shared = BuildingsDataStore()
    var buildings: [Building]?
    var selectedBuilding: Building?
    
    private init() { }
}
