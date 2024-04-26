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
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
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
    func loadMore(_ request: Model.More.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadProfile(_ request: Model.Profile.Request)
    func loadAccountCarsRequest(_ request: Model.AccountCarsRequest.Request)
    func loadCarDetails(_ request: Model.CarDetails.Request)
    func loadAddCar(_ request: Model.AddCar.Request)
}

// MARK: - PresentationLogic
protocol AccountCarsPresentationLogic {
    typealias Model = AccountCarsModel
    func presentStart(_ response: Model.Start.Response)
    func presentMore(_ response: Model.More.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentProfile(_ response: Model.Profile.Response)
    func presentAccountCarsRequest(_ response: Model.AccountCarsRequest.Response)
    func presentCarDetails(_ response: Model.CarDetails.Response)
    func presentAddCar(_ response: Model.AddCar.Response)
    func presentAccountCarsFailure(_ response: Model.AccountCarsFailure.Response)
}

// MARK: - RoutingLogic
protocol AccountCarsRoutingLogic {
    typealias Model = AccountCarsModel
    func routeToMore()
    func routeToHome()
    func routeToProfile()
    func routeToCarDetails(_ routeData: Model.CarDetails.RouteData)
    func routeToAddCar()
}
