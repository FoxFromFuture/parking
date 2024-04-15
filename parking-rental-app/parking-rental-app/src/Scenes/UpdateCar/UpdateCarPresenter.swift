//
//  UpdateCarPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

final class UpdateCarPresenter {
    // MARK: - Properties
    weak var view: UpdateCarDisplayLogic?
}

// MARK: - PresentationLogic
extension UpdateCarPresenter: UpdateCarPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentProfile(_ response: Model.Profile.Response) {
        view?.displayProfile(Model.Profile.ViewModel())
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(Model.More.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentUpdateCarRequest(_ response: Model.UpdateCarRequest.Response) {
        view?.displayUpdateCarRequest(UpdateCarModel.UpdateCarRequest.ViewModel())
    }
    
    func presentUpdateCarFailure(_ response: Model.CarUpdateFailure.Response) {
        view?.displayUpdateCarFailure(UpdateCarModel.CarUpdateFailure.ViewModel())
    }
}
