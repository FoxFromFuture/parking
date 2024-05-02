//
//  NotAuthMoreProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/29/24.
//

// MARK: - DisplayLogic
protocol NotAuthMoreDisplayLogic: AnyObject {
    typealias Model = NotAuthMoreModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayNotAuthSettings(_ viewModel: Model.NotAuthSettings.ViewModel)
    func displayNotAuthContactDevs(_ viewModel: Model.NotAuthContactDevs.ViewModel)
}

// MARK: - BusinessLogic
protocol NotAuthMoreBusinessLogic {
    typealias Model = NotAuthMoreModel
    func loadStart(_ request: Model.Start.Request)
    func loadNotAuthSettings(_ request: Model.NotAuthSettings.Request)
    func loadNotAuthContactDevs(_ request: Model.NotAuthContactDevs.Request)
}

// MARK: - PresentationLogic
protocol NotAuthMorePresentationLogic {
    typealias Model = NotAuthMoreModel
    func presentStart(_ response: Model.Start.Response)
    func presentNotAuthSettings(_ response: Model.NotAuthSettings.Response)
    func presentNotAuthContactDevs(_ response: Model.NotAuthContactDevs.Response)
}

// MARK: - RoutingLogic
protocol NotAuthMoreRoutingLogic {
    func routeToNotAuthSettings()
    func routeToNotAuthContactDevs()
}
