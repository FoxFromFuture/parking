//
//  FAQProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

// MARK: - DisplayLogic
protocol FAQDisplayLogic: AnyObject {
    typealias Model = FAQModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
}

// MARK: - BusinessLogic
protocol FAQBusinessLogic {
    typealias Model = FAQModel
    func loadStart(_ request: Model.Start.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadMore(_ request: Model.More.Request)
}

// MARK: - PresentationLogic
protocol FAQPresentationLogic {
    typealias Model = FAQModel
    func presentStart(_ response: Model.Start.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentMore(_ response: Model.More.Response)
}

// MARK: - RoutingLogic
protocol FAQRoutingLogic {
    func routeToHome()
    func routeToMore()
}
