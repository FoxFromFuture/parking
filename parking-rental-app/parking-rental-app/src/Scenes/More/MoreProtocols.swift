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
    func displaySettings(_ viewModel: Model.Settings.ViewModel)
    func displayFAQ(_ viewModel: Model.FAQ.ViewModel)
    func displayContactDevs(_ viewModel: Model.ContactDevs.ViewModel)
}

// MARK: - BusinessLogic
protocol MoreBusinessLogic {
    typealias Model = MoreModel
    func loadStart(_ request: Model.Start.Request)
    func loadSettings(_ request: Model.Settings.Request)
    func loadFAQ(_ request: Model.FAQ.Request)
    func loadContactDevs(_ request: Model.ContactDevs.Request)
}

// MARK: - PresentationLogic
protocol MorePresentationLogic {
    typealias Model = MoreModel
    func presentStart(_ response: Model.Start.Response)
    func presentSettings(_ response: Model.Settings.Response)
    func presentFAQ(_ response: Model.FAQ.Response)
    func presentContactDevs(_ response: Model.ContactDevs.Response)
}

// MARK: - RoutingLogic
protocol MoreRoutingLogic {
    func routeToSettings()
    func routeToFAQ()
    func routeToContactDevs()
}
