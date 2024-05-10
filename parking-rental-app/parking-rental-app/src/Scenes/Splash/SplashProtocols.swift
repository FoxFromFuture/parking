//
//  SplashProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

// MARK: - DisplayLogic
protocol SplashDisplayLogic: AnyObject {
    typealias Model = SplashModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayLogin(_ viewModel: Model.Login.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
}

// MARK: - BusinessLogic
protocol SplashBusinessLogic {
    typealias Model = SplashModel
    func loadStart(_ request: Model.Start.Request)
    func loadLogin(_ request: Model.Login.Request)
}

// MARK: - PresentationLogic
protocol SplashPresentationLogic {
    typealias Model = SplashModel
    func presentStart(_ response: Model.Start.Response)
    func presentLogin(_ response: Model.Login.Response)
    func presentHome(_ response: Model.Home.Response)
}

// MARK: - RoutingLogic
protocol SplashRoutingLogic {
    func routeToLogin()
    func routeToHome()
}
