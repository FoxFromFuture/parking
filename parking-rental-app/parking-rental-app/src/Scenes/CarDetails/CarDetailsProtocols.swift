//
//  CarDetailsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

// MARK: - DisplayLogic
protocol CarDetailsDisplayLogic: AnyObject {
    typealias Model = CarDetailsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayCarDetails(_ viewModel: Model.CarDetails.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayAccountCars(_ viewModel: Model.AccountCars.ViewModel)
    func displayUpdateCar(_ viewModel: Model.UpdateCar.ViewModel)
    func displayDeleteCar(_ viewModel: Model.DeleteCar.ViewModel)
    func displayCarDetailsFailure(_ viewModel: Model.CarDetailsFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol CarDetailsBusinessLogic {
    typealias Model = CarDetailsModel
    func loadStart(_ request: Model.Start.Request)
    func loadCarDetails(_ request: Model.CarDetails.Request)
    func loadMore(_ request: Model.More.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadAccountCars(_ request: Model.AccountCars.Request)
    func loadUpdateCar(_ request: Model.UpdateCar.Request)
    func loadDeleteCar(_ request: Model.DeleteCar.Request)
}

// MARK: - PresentationLogic
protocol CarDetailsPresentationLogic {
    typealias Model = CarDetailsModel
    func presentStart(_ response: Model.Start.Response)
    func presentCarDetails(_ response: Model.CarDetails.Response)
    func presentMore(_ response: Model.More.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentAccountCars(_ response: Model.AccountCars.Response)
    func presentUpdateCar(_ response: Model.UpdateCar.Response)
    func presentDeleteCar(_ response: Model.DeleteCar.Response)
    func presentCarDetailsFailure(_ response: Model.CarDetailsFailure.Response)
}

// MARK: - RoutingLogic
protocol CarDetailsRoutingLogic {
    typealias Model = CarDetailsModel
    func routeToMore()
    func routeToHome()
    func routeToAccountCars()
    func routeToUpdateCar(_ routeData: Model.UpdateCar.RouteData)
}
