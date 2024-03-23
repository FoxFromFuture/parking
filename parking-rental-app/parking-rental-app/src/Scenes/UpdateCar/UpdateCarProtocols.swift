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
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayUpdateCarRequest(_ viewModel: Model.UpdateCarRequest.ViewModel)
}

// MARK: - BusinessLogic
protocol UpdateCarBusinessLogic {
    typealias Model = UpdateCarModel
    func loadStart(_ request: Model.Start.Request)
    func loadProfile(_ request: Model.Profile.Request)
    func loadMore(_ request: Model.More.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadUpdateCarRequest(_ request: Model.UpdateCarRequest.Request)
}

// MARK: - PresentationLogic
protocol UpdateCarPresentationLogic {
    typealias Model = UpdateCarModel
    func presentStart(_ response: Model.Start.Response)
    func presentProfile(_ response: Model.Profile.Response)
    func presentMore(_ response: Model.More.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentUpdateCarRequest(_ response: Model.UpdateCarRequest.Response)
}

// MARK: - RoutingLogic
protocol UpdateCarRoutingLogic {
    func routeToProfile()
    func routeToMore()
    func routeToHome()
}

// MARK: - WorkerLogic
protocol UpdateCarWorkerLogic {
    typealias Model = UpdateCarModel
    func updateCar(id: String, newRegistryNumber: String, completion: @escaping (_ carData: Car?, _ error: String?) -> ())
    func getAllCars(completion: @escaping (_ carsData: [Car]?, _ error: String?) -> ())
}
