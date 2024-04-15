//
//  MoreProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

// MARK: - DisplayLogic
protocol MoreDisplayLogic: AnyObject {
    typealias Model = MoreModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayNewTheme(_ viewModel: Model.NewTheme.ViewModel)
}

// MARK: - BusinessLogic
protocol MoreBusinessLogic {
    typealias Model = MoreModel
    func loadStart(_ request: Model.Start.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadNewTheme(_ request: Model.NewTheme.Request)
}

// MARK: - PresentationLogic
protocol MorePresentationLogic {
    typealias Model = MoreModel
    func presentStart(_ response: Model.Start.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentNewTheme(_ response: Model.NewTheme.Response)
}

// MARK: - RoutingLogic
protocol MoreRoutingLogic {
    func routeToHome()
}

// MARK: - WorkerLogic
protocol MoreWorkerLogic {
    typealias Model = MoreModel
    
}
