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
    func displayRegistrationCity(_ viewModel: RegistrationModel.RegistrationCity.ViewModel)
}

// MARK: - BusinessLogic
protocol RegistrationBusinessLogic {
    typealias Model = RegistrationModel
    func loadStart(_ request: RegistrationModel.Start.Request)
    func loadRegistrationCity(_ request: RegistrationModel.RegistrationCity.Request)
}

// MARK: - PresentationLogic
protocol RegistrationPresentationLogic {
    typealias Model = RegistrationModel
    func presentStart(_ response: RegistrationModel.Start.Response)
    func presentRegistrationCity(_ response: RegistrationModel.RegistrationCity.Response)
}

// MARK: - RoutingLogic
protocol RegistrationRoutingLogic {
    func routeToRegistrationCity()
}

// MARK: - WorkerLogic
protocol RegistrationWorkerLogic {
    typealias Model = RegistrationModel
    func signUp(_ request: RegistrationModel.RegistrationCity.Request, completion: @escaping (_ authData: AuthApiResponse?, _ error: String?) -> ())
    func saveAuthTokens(refreshToken: String, accessToken: String)
}
