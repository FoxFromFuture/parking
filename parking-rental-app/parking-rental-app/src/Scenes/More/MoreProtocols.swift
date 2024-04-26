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
    func displaySettings(_ viewModel: Model.Settings.ViewModel)
    func displayFAQ(_ viewModel: Model.FAQ.ViewModel)
}

// MARK: - BusinessLogic
protocol MoreBusinessLogic {
    typealias Model = MoreModel
    func loadStart(_ request: Model.Start.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadSettings(_ request: Model.Settings.Request)
    func loadFAQ(_ request: Model.FAQ.Request)
}

// MARK: - PresentationLogic
protocol MorePresentationLogic {
    typealias Model = MoreModel
    func presentStart(_ response: Model.Start.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentSettings(_ response: Model.Settings.Response)
    func presentFAQ(_ response: Model.FAQ.Response)
}

// MARK: - RoutingLogic
protocol MoreRoutingLogic {
    func routeToHome()
    func routeToSettings()
    func routeToFAQ()
}
