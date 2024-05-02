//
//  CarDetailsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

final class CarDetailsPresenter {
    // MARK: - Properties
    weak var view: CarDetailsDisplayLogic?
}

// MARK: - PresentationLogic
extension CarDetailsPresenter: CarDetailsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentCarDetails(_ response: Model.CarDetails.Response) {
        view?.displayCarDetails(CarDetailsModel.CarDetails.ViewModel(model: response.car.model, registryNumber: response.car.registryNumber, isOnlyOneCarLasts: response.isOnlyOneCarLasts))
    }
    
    func presentAccountCars(_ response: Model.AccountCars.Response) {
        view?.displayAccountCars(CarDetailsModel.AccountCars.ViewModel())
    }
    
    func presentUpdateCar(_ response: Model.UpdateCar.Response) {
        view?.displayUpdateCar(CarDetailsModel.UpdateCar.ViewModel(carID: response.carID))
    }
    
    func presentDeleteCar(_ response: Model.DeleteCar.Response) {
        view?.displayDeleteCar(CarDetailsModel.DeleteCar.ViewModel())
    }
    
    func presentCarDetailsFailure(_ response: Model.CarDetailsFailure.Response) {
        view?.displayCarDetailsFailure(CarDetailsModel.CarDetailsFailure.ViewModel())
    }
}
