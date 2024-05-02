//
//  AddCarPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

final class AddCarPresenter {
    // MARK: - Properties
    weak var view: AddCarDisplayLogic?
}

// MARK: - PresentationLogic
extension AddCarPresenter: AddCarPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }

    func presentAccountCars(_ response: Model.AccountCars.Response) {
        view?.displayAccountCars(Model.AccountCars.ViewModel())
    }
    
    func presentAddCarRequest(_ response: Model.AddCarRequest.Response) {
        view?.displayAddCarRequest(AddCarModel.AddCarRequest.ViewModel())
    }
    
    func presentAddCarFailure(_ response: Model.AddCarFailure.Response) {
        view?.displayAddCarFailure(AddCarModel.AddCarFailure.ViewModel())
    }
}
