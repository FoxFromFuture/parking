//
//  RegistrationCityPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

final class RegistrationCityPresenter {
    // MARK: - Properties
    weak var view: RegistrationCityDisplayLogic?
}

// MARK: - PresentationLogic
extension RegistrationCityPresenter: RegistrationCityPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentRegistrationCar(_ response: RegistrationCityModel.RegistrationCar.Response) {
        view?.displayRegistrationCar(Model.RegistrationCar.ViewModel())
    }
}
