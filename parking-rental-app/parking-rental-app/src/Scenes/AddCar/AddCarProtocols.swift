//
//  AddCarProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

// MARK: - DisplayLogic
protocol AddCarDisplayLogic: AnyObject {
    typealias Model = AddCarModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayAccountCars(_ viewModel: Model.AccountCars.ViewModel)
    func displayAddCarRequest(_ viewModel: Model.AddCarRequest.ViewModel)
    func displayAddCarFailure(_ viewModel: Model.AddCarFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol AddCarBusinessLogic {
    typealias Model = AddCarModel
    func loadStart(_ request: Model.Start.Request)
    func loadAccountCars(_ request: Model.AccountCars.Request)
    func loadAddCarRequest(_ request: Model.AddCarRequest.Request)
}

// MARK: - PresentationLogic
protocol AddCarPresentationLogic {
    typealias Model = AddCarModel
    func presentStart(_ response: Model.Start.Response)
    func presentAccountCars(_ response: Model.AccountCars.Response)
    func presentAddCarRequest(_ response: Model.AddCarRequest.Response)
    func presentAddCarFailure(_ response: Model.AddCarFailure.Response)
}

// MARK: - RoutingLogic
protocol AddCarRoutingLogic {
    func routeToAccountCars()
}
