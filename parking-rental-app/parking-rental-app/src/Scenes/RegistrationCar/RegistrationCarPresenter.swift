//
//  RegistrationCarPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

final class RegistrationCarPresenter {
    // MARK: - Properties
    weak var view: RegistrationCarDisplayLogic?
}

// MARK: - PresentationLogic
extension RegistrationCarPresenter: RegistrationCarPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentHome(_ response: RegistrationCarModel.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentCarSetupFailure(_ response: RegistrationCarModel.CarSetupFailure.Response) {
        view?.displayCarSetupFailure(RegistrationCarModel.CarSetupFailure.ViewModel())
    }
}
