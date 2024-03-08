//
//  RegistrationPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

final class RegistrationPresenter {
    // MARK: - Properties
    weak var view: RegistrationDisplayLogic?
}

// MARK: - PresentationLogic
extension RegistrationPresenter: RegistrationPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentRegistrationCity(_ response: RegistrationModel.RegistrationCity.Response) {
        view?.displayRegistrationCity(Model.RegistrationCity.ViewModel())
    }
}
