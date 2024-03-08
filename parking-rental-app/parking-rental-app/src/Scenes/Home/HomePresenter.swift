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
        
        view?.displayReservations(Model.GetReservations.ViewModel())
    }
}
