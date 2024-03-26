//
//  MapInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MapInteractor {
    // MARK: - Private Properties
    private let presenter: MapPresentationLogic
    private let worker: MapWorkerLogic
    private var initialLevelID: String?
    private var initialLevelCanvas: Canvas?
    
    // MARK: - Initializers
    init(presenter: MapPresentationLogic, worker: MapWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension MapInteractor: MapBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadParkingMap(_ request: Model.ParkingMap.Request) {
        /// Check if Map was opened for displaying initial building level or for displaying reservation
        if let buildingForMapID = BuildingsDataStore.shared.buildingForMapID {
            /// Clear one-time building data
            BuildingsDataStore.shared.buildingForMapID = nil
            
            
        } else if let reservatiomForMapID = ReservationsDataStore.shared.reservationForMapID {
            /// Clear one-time reservation data
            ReservationsDataStore.shared.reservationForMapID = nil
            
            
        }
        
        guard let buildingForMapID = BuildingsDataStore.shared.buildingForMapID else { return }
    
        self.worker.getAllBuildingLevels(buildingID: buildingForMapID) { [weak self] levelsData, error in
            if let error = error {
                print(error)
//                self?.presenter.presentLoadingFailure(BuildingsModel.LoadingFailure.Response())
            } else if let parkingLevels = levelsData, !parkingLevels.isEmpty {
                for level in parkingLevels {
                    if level.levelNumber == 0 {
                        self?.initialLevelID = level.id
                        self?.initialLevelCanvas = level.canvas
                        break
                    }
                }
                
                guard let initialLevelID = self?.initialLevelID, let initialLevelCanvas = self?.initialLevelCanvas else { return }
                
                self?.worker.getAllLevelSpots(parkingLevelID: initialLevelID, completion: { [weak self] parkingSpotsData, error in
                    if let error = error {
                        print(error)
                    } else if let parkingSpots = parkingSpotsData, !parkingSpots.isEmpty {
                        self?.presenter.presentParkingMap(MapModel.ParkingMap.Response(parkingSpots: parkingSpots, parkingLevelCanvas: initialLevelCanvas))
                    }
                })
            }
        }
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(MapModel.Home.Response())
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(MapModel.More.Response())
    }
    
    func loadPreviousScene(_ request: Model.PreviousScene.Request) {
        presenter.presentPreviousScene(MapModel.PreviousScene.Response())
    }
}
