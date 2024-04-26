//
//  AccountCarsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

final class AccountCarsPresenter {
    // MARK: - Properties
    weak var view: AccountCarsDisplayLogic?
}

// MARK: - PresentationLogic
extension AccountCarsPresenter: AccountCarsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(Model.More.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentProfile(_ response: Model.Profile.Response) {
        view?.displayProfile(Model.Profile.ViewModel())
    }
    
    func presentAccountCarsRequest(_ response: Model.AccountCarsRequest.Response) {
        view?.displayAccountCarsRequest(Model.AccountCarsRequest.ViewModel(isLimit: response.isLimit, cars: response.cars))
    }
    
    func presentCarDetails(_ response: Model.CarDetails.Response) {
        view?.displayCarDetails(Model.CarDetails.ViewModel(carID: response.carID))
    }
    
    func presentAddCar(_ response: Model.AddCar.Response) {
        view?.displayAddCar(Model.AddCar.ViewModel())
    }
    
    func presentAccountCarsFailure(_ response: Model.AccountCarsFailure.Response) {
        view?.displayAccountCarsFailure(AccountCarsModel.AccountCarsFailure.ViewModel())
    }
}
