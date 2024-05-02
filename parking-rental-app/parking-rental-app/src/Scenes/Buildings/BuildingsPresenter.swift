//
//  BuildingsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

final class BuildingsPresenter {
    // MARK: - Properties
    weak var view: BuildingsDisplayLogic?
}

// MARK: - PresentationLogic
extension BuildingsPresenter: BuildingsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentBuildings(_ response: Model.GetBuildings.Response) {
        /// Prepare datastores
        var buildingNames: [String] = []
        var buildingAddresses: [String] = []
        var buildingsIDx: [String] = []
        
        /// Retrieve "buildingNames" and "buildingAddresses" from buildings
        for building in response.buildings {
            buildingNames.append(building.name)
            buildingAddresses.append(building.address)
            buildingsIDx.append(building.id)
        }
        
        view?.displayBuildings(BuildingsModel.GetBuildings.ViewModel(buildingsCount: response.buildings.count, buildingNames: buildingNames, buildingAddresses: buildingAddresses, buildingsIDx: buildingsIDx))
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentMap(_ response: Model.Map.Response) {
        view?.displayMap(Model.Map.ViewModel(buildingID: response.buildingID))
    }
    
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response) {
        view?.displayLoadingFailure(BuildingsModel.LoadingFailure.ViewModel())
    }
}
