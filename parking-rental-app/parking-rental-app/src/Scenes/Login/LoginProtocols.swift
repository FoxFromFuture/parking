//
//  LoginProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

// MARK: - DisplayLogic
protocol LoginDisplayLogic: AnyObject {
    typealias Model = LoginModel
    func displayStart(_ viewModel: LoginModel.Start.ViewModel)
    func displayHome(_ viewModel: LoginModel.Home.ViewModel)
    func displayRegistration(_ viewModel: LoginModel.Registration.ViewModel)
    func displayLoginFailure(_ viewModel: LoginModel.LoginFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol LoginBusinessLogic {
    typealias Model = LoginModel
    func loadStart(_ request: LoginModel.Start.Request)
    func loadHome(_ request: LoginModel.Home.Request)
    func loadRegistration(_ request: LoginModel.Registration.Request)
}

// MARK: - PresentationLogic
protocol LoginPresentationLogic {
    typealias Model = LoginModel
    func presentStart(_ response: LoginModel.Start.Response)
    func presentHome(_ response: LoginModel.Home.Response)
    func presentRegistration(_ response: LoginModel.Registration.Response)
    func presentLoginFailure(_ response: LoginModel.LoginFailure.Response)
}

// MARK: - RoutingLogic
protocol LoginRoutingLogic {
    func routeToHome()
    func routeToRegistration()
}
