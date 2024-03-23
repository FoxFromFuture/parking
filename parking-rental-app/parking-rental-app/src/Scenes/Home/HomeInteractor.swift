//
//  HomeInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class HomeInteractor {
    // MARK: - Private Properties
    private let presenter: HomePresentationLogic
    private let worker: HomeWorkerLogic
    
    // MARK: - Initializers
    init(presenter: HomePresentationLogic, worker: HomeWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadReservations(_ request: Model.GetReservations.Request) {
        self.worker.getReservations() { reservationsData, error in
            if let error = error {
                print(error)
                /// TODO: Present failure
            } else if let data = reservationsData {
                ReservationsDataStore.shared.reservations = data
            }
        }
        self.worker.getParkingSpots(completion: { parkingSpotsData, error in
            if let error = error {
                print(error)
            } else if let data = parkingSpotsData {
                ParkingSpotsDataStore.shared.parkingSpots = data
            }
        })
        self.worker.getAllParkingLevels(completion: { parkingLevelsData, error in
            if let error = error {
                print(error)
            } else if let data = parkingLevelsData {
                ParkingLevelsDataStore.shared.parkingLevels = data
            }
        })
        self.worker.getAllBuildings(completion: { buildingsData, error in
            if let error = error {
                print(error)
            } else if let data = buildingsData {
                BuildingsDataStore.shared.buildings = data
            }
        })
        
        var spotNumbers: [String]?
        var levelNumbers: [String]?
        var buildingNames: [String]?
        
        if let reservs = ReservationsDataStore.shared.reservations {
            if let spots = ParkingSpotsDataStore.shared.parkingSpots {
                spotNumbers = []
                for reserv in reservs {
                    for spot in spots {
                        if reserv.parkingSpotId == spot.id {
                            spotNumbers?.append(spot.parkingNumber)
                        }
                    }
                }
                if let levels = ParkingLevelsDataStore.shared.parkingLevels {
                    levelNumbers = []
                    for spot in spots {
                        for level in levels {
                            if spot.levelId == level.id {
                                levelNumbers?.append("\(level.levelNumber)")
                            }
                        }
                    }
                }
                if let buildings = BuildingsDataStore.shared.buildings {
                    buildingNames = []
                    for spot in spots {
                        for building in buildings {
                            if spot.buildingId == building.id {
                                buildingNames?.append(building.name)
                            }
                        }
                    }
                }
            }
        }
        self.presenter.presentReservations(Model.GetReservations.Response(spotNumbers: spotNumbers, levelNumbers: levelNumbers, buildingNames: buildingNames))
    }
    
    func loadBuildings(_ request: Model.Buildings.Request) {
        self.presenter.presentBuildings(Model.Buildings.Response())
    }
    
    func loadMap(_ request: Model.Map.Request) {
        ParkingSpotsDataStore.shared.parkingSpotForMapID = request.lotID
        self.presenter.presentMap(Model.Map.Response())
    }
    
    func loadProfile(_ request: Model.Profile.Request) {
        self.presenter.presentProfile(Model.Profile.Response())
    }
    
    func loadMore(_ request: Model.More.Request) {
        self.presenter.presentMore(Model.More.Response())
    }
}
