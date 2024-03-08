//
//  RegistrationCarProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

// MARK: - DisplayLogic
protocol RegistrationCarDisplayLogic: AnyObject {
    typealias Model = RegistrationCarModel
    func displayStart(_ viewModel: RegistrationCarModel.Start.ViewModel)
    func displayHome(_ viewModel: RegistrationCarModel.Home.ViewModel)
}

// MARK: - BusinessLogic
protocol RegistrationCarBusinessLogic {
    typealias Model = RegistrationCarModel
    func loadStart(_ request: RegistrationCarModel.Start.Request)
    func loadHome(_ request: RegistrationCarModel.Home.Request)
}

// MARK: - PresentationLogic
protocol RegistrationCarPresentationLogic {
    typealias Model = RegistrationCarModel
    func presentStart(_ response: RegistrationCarModel.Start.Response)
    func presentHome(_ response: RegistrationCarModel.Home.Response)
}

// MARK: - RoutingLogic
protocol RegistrationCarRoutingLogic {
    func routeToHome()
}

// MARK: - WorkerLogic
protocol RegistrationCarWorkerLogic {
    typealias Model = RegistrationCarModel
    func saveCarRegistryNumber(registryNumber: String)
}
