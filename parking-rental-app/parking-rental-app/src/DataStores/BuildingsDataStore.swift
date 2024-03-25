//
//  BuildingsDataStore.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/8/24.
//

final class BuildingsDataStore {
    
    static let shared = BuildingsDataStore()
    var buildingForMapID: String?
    
    private init() { }
}
