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
    
    func presentRegistrationCar(_ response: RegistrationModel.RegistrationCar.Response) {
        view?.displayRegistrationCar(Model.RegistrationCar.ViewModel())
    }
    
    func presentLogin(_ response: RegistrationModel.Login.Response) {
        view?.displayLogin(Model.Login.ViewModel())
    }
}
