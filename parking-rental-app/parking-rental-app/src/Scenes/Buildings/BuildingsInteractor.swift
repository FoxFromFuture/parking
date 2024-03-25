//
//  BuildingsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

final class BuildingsInteractor {
    // MARK: - Private Properties
    private let presenter: BuildingsPresentationLogic
    private let worker: BuildingsWorkerLogic
    
    // MARK: - Initializers
    init(presenter: BuildingsPresentationLogic, worker: BuildingsWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension BuildingsInteractor: BuildingsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadBuildings(_ request: Model.GetBuildings.Request) {
        /// Fetch all buildings data
        self.worker.getAllBuildings(completion: { [weak self] buildingsData, error in
            if let error = error {
                print(error)
                self?.presenter.presentLoadingFailure(BuildingsModel.LoadingFailure.Response())
            } else if let buildings = buildingsData, !buildings.isEmpty {
                self?.presenter.presentBuildings(BuildingsModel.GetBuildings.Response(buildings: buildings))
            }
        })
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(Model.More.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(Model.Home.Response())
    }
    
    func loadMap(_ request: Model.Map.Request) {
        BuildingsDataStore.shared.buildingForMapID = request.buildingID
        presenter.presentMap(Model.Map.Response())
    }
}
