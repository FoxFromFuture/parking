//
//  ProfileProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

// MARK: - DisplayLogic
protocol ProfileDisplayLogic: AnyObject {
    typealias Model = ProfileModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayUpdateCar(_ viewModel: Model.UpdateCar.ViewModel)
    func displayLogin(_ viewModel: Model.Login.ViewModel)
}

// MARK: - BusinessLogic
protocol ProfileBusinessLogic {
    typealias Model = ProfileModel
    func loadStart(_ request: Model.Start.Request)
    func loadMore(_ request: Model.More.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadUpdateCar(_ request: Model.UpdateCar.Request)
    func loadLogin(_ request: Model.Login.Request)
}

// MARK: - PresentationLogic
protocol ProfilePresentationLogic {
    typealias Model = ProfileModel
    func presentStart(_ response: Model.Start.Response)
    func presentMore(_ response: Model.More.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentUpdateCar(_ response: Model.UpdateCar.Response)
    func presentLogin(_ response: Model.Login.Response)
}

// MARK: - RoutingLogic
protocol ProfileRoutingLogic {
    func routeToMore()
    func routeToHome()
    func routeToUpdateCar()
    func routeToLogin()
}

// MARK: - WorkerLogic
protocol ProfileWorkerLogic {
    typealias Model = ProfileModel
    func clearUserData()
}
