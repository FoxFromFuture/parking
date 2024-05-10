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
    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    init(presenter: BuildingsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension BuildingsInteractor: BuildingsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadBuildings(_ request: Model.GetBuildings.Request) {
        /// Fetch all buildings data
        self.networkManager.getAllBuildings { [weak self] buildingsData, error in
            if let error = error {
                print(error)
                self?.presenter.presentLoadingFailure(BuildingsModel.LoadingFailure.Response())
            } else if let buildings = buildingsData, !buildings.isEmpty {
                self?.presenter.presentBuildings(BuildingsModel.GetBuildings.Response(buildings: buildings))
            }
        }
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(Model.Home.Response())
    }
    
    func loadMap(_ request: Model.Map.Request) {
        presenter.presentMap(Model.Map.Response(buildingID: request.buildingID))
    }
}
