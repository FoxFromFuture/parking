//
//  AccountCarsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

// MARK: - DisplayLogic
protocol AccountCarsDisplayLogic: AnyObject {
    typealias Model = AccountCarsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayProfile(_ viewModel: Model.Profile.ViewModel)
    func displayAccountCarsRequest(_ viewModel: Model.AccountCarsRequest.ViewModel)
    func displayCarDetails(_ viewModel: Model.CarDetails.ViewModel)
    func displayAddCar(_ viewModel: Model.AddCar.ViewModel)
    func displayAccountCarsFailure(_ viewModel: Model.AccountCarsFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol AccountCarsBusinessLogic {
    typealias Model = AccountCarsModel
    func loadStart(_ request: Model.Start.Request)
    func loadProfile(_ request: Model.Profile.Request)
    func loadAccountCarsRequest(_ request: Model.AccountCarsRequest.Request)
    func loadCarDetails(_ request: Model.CarDetails.Request)
    func loadAddCar(_ request: Model.AddCar.Request)
}

// MARK: - PresentationLogic
protocol AccountCarsPresentationLogic {
    typealias Model = AccountCarsModel
    func presentStart(_ response: Model.Start.Response)
    func presentProfile(_ response: Model.Profile.Response)
    func presentAccountCarsRequest(_ response: Model.AccountCarsRequest.Response)
    func presentCarDetails(_ response: Model.CarDetails.Response)
    func presentAddCar(_ response: Model.AddCar.Response)
    func presentAccountCarsFailure(_ response: Model.AccountCarsFailure.Response)
}

// MARK: - RoutingLogic
protocol AccountCarsRoutingLogic {
    typealias Model = AccountCarsModel
    func routeToProfile()
    func routeToCarDetails(_ routeData: Model.CarDetails.RouteData)
    func routeToAddCar()
}
