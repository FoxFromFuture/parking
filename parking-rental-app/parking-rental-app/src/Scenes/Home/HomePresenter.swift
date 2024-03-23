//
//  HomePresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

final class HomePresenter {
    // MARK: - Properties
    weak var view: HomeDisplayLogic?
}

// MARK: - PresentationLogic
extension HomePresenter: HomePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentReservations(_ response: Model.GetReservations.Response) {
        view?.displayReservations(Model.GetReservations.ViewModel(spotNumbers: response.spotNumbers, levelNumbers: response.levelNumbers, buildingNames: response.buildingNames))
    }
    
    func presentBuildings(_ response: Model.Buildings.Response) {
        view?.displayBuildings(Model.Buildings.ViewModel())
    }
    
    func presentMap(_ response: Model.Map.Response) {
        view?.displayMap(Model.Map.ViewModel())
    }
    
    func presentProfile(_ response: Model.Profile.Response) {
        view?.displayProfile(Model.Profile.ViewModel())
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(Model.More.ViewModel())
    }
}
