//
//  RegistrationProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

// MARK: - DisplayLogic
protocol RegistrationDisplayLogic: AnyObject {
    typealias Model = RegistrationModel
    func displayStart(_ viewModel: RegistrationModel.Start.ViewModel)
    func displayRegistrationCar(_ viewModel: RegistrationModel.RegistrationCar.ViewModel)
    func displayLogin(_ viewModel: RegistrationModel.Login.ViewModel)
}

// MARK: - BusinessLogic
protocol RegistrationBusinessLogic {
    typealias Model = RegistrationModel
    func loadStart(_ request: RegistrationModel.Start.Request)
    func loadRegistrationCar(_ request: RegistrationModel.RegistrationCar.Request)
    func loadLogin(_ request: RegistrationModel.Login.Request)
}

// MARK: - PresentationLogic
protocol RegistrationPresentationLogic {
    typealias Model = RegistrationModel
    func presentStart(_ response: RegistrationModel.Start.Response)
    func presentRegistrationCar(_ response: RegistrationModel.RegistrationCar.Response)
    func presentLogin(_ response: RegistrationModel.Login.Response)
}

// MARK: - RoutingLogic
protocol RegistrationRoutingLogic {
    func routeToRegistrationCar()
    func routeToLogin()
}

// MARK: - WorkerLogic
protocol RegistrationWorkerLogic {
    typealias Model = RegistrationModel
    func signUp(_ request: RegistrationModel.RegistrationCar.Request, completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ())
    func saveAuthTokens(refreshToken: String, accessToken: String)
}
