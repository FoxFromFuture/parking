//
//  RegistrationCityProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

// MARK: - DisplayLogic
protocol RegistrationCityDisplayLogic: AnyObject {
    typealias Model = RegistrationCityModel
    func displayStart(_ viewModel: RegistrationCityModel.Start.ViewModel)
    func displayRegistrationCar(_ viewModel: RegistrationCityModel.RegistrationCar.ViewModel)
}

// MARK: - BusinessLogic
protocol RegistrationCityBusinessLogic {
    typealias Model = RegistrationCityModel
    func loadStart(_ request: RegistrationCityModel.Start.Request)
    func loadRegistrationCar(_ request: RegistrationCityModel.RegistrationCar.Request)
}

// MARK: - PresentationLogic
protocol RegistrationCityPresentationLogic {
    typealias Model = RegistrationCityModel
    func presentStart(_ response: RegistrationCityModel.Start.Response)
    func presentRegistrationCar(_ response: RegistrationCityModel.RegistrationCar.Response)
}

// MARK: - RoutingLogic
protocol RegistrationCityRoutingLogic {
    func routeToRegistrationCar()
}

// MARK: - WorkerLogic
protocol RegistrationCityWorkerLogic {
    typealias Model = RegistrationCityModel
    func saveCity(city: String)
}
