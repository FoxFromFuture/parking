//
//  MapPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

final class MapPresenter {
    // MARK: - Properties
    weak var view: MapDisplayLogic?
}

// MARK: - PresentationLogic
extension MapPresenter: MapPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(MapModel.Home.ViewModel()     )
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(MapModel.More.ViewModel())
    }
    
    func presentPreviousScene(_ response: Model.PreviousScene.Response) {
        view?.displayPreviousScene(MapModel.PreviousScene.ViewModel())
    }
}
