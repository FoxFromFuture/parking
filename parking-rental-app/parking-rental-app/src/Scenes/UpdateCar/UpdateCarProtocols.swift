//
//  UpdateCarProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

// MARK: - DisplayLogic
protocol UpdateCarDisplayLogic: AnyObject {
    typealias Model = UpdateCarModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayProfile(_ viewModel: Model.Profile.ViewModel)
    func displayUpdateCarRequest(_ viewModel: Model.UpdateCarRequest.ViewModel)
    func displayUpdateCarFailure(_ viewModel: Model.CarUpdateFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol UpdateCarBusinessLogic {
    typealias Model = UpdateCarModel
    func loadStart(_ request: Model.Start.Request)
    func loadProfile(_ request: Model.Profile.Request)
    func loadUpdateCarRequest(_ request: Model.UpdateCarRequest.Request)
}

// MARK: - PresentationLogic
protocol UpdateCarPresentationLogic {
    typealias Model = UpdateCarModel
    func presentStart(_ response: Model.Start.Response)
    func presentProfile(_ response: Model.Profile.Response)
    func presentUpdateCarRequest(_ response: Model.UpdateCarRequest.Response)
    func presentUpdateCarFailure(_ response: Model.CarUpdateFailure.Response)
}

// MARK: - RoutingLogic
protocol UpdateCarRoutingLogic {
    func routeToProfile()
}
