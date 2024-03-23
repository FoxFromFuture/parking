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
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(Model.More.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentMap(_ response: Model.Map.Response) {
        view?.displayMap(Model.Map.ViewModel())
    }
}
