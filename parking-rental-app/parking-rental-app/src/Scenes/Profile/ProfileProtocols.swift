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
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayAccountCars(_ viewModel: Model.AccountCars.ViewModel)
    func displayLogin(_ viewModel: Model.Login.ViewModel)
    func displayAccountDetails(_ viewModel: Model.AccountDetails.ViewModel)
}

// MARK: - BusinessLogic
protocol ProfileBusinessLogic {
    typealias Model = ProfileModel
    func loadStart(_ request: Model.Start.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadAccountCars(_ request: Model.AccountCars.Request)
    func loadLogin(_ request: Model.Login.Request)
    func loadAccountDetails(_ request: Model.AccountDetails.Request)
}

// MARK: - PresentationLogic
protocol ProfilePresentationLogic {
    typealias Model = ProfileModel
    func presentStart(_ response: Model.Start.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentAccountCars(_ response: Model.AccountCars.Response)
    func presentLogin(_ response: Model.Login.Response)
    func presentAccountDetails(_ response: Model.AccountDetails.Response)
}

// MARK: - RoutingLogic
protocol ProfileRoutingLogic {
    func routeToHome()
    func routeToAccountCars()
    func routeToLogin()
    func routeToAccountDetails()
}
