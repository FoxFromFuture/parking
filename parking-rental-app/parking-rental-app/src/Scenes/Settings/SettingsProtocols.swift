//
//  SettingsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

// MARK: - DisplayLogic
protocol SettingsDisplayLogic: AnyObject {
    typealias Model = SettingsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayNewTheme(_ viewModel: Model.NewTheme.ViewModel)
}

// MARK: - BusinessLogic
protocol SettingsBusinessLogic {
    typealias Model = SettingsModel
    func loadStart(_ request: Model.Start.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadMore(_ request: Model.More.Request)
    func loadNewTheme(_ request: Model.NewTheme.Request)
}

// MARK: - PresentationLogic
protocol SettingsPresentationLogic {
    typealias Model = SettingsModel
    func presentStart(_ response: Model.Start.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentMore(_ response: Model.More.Response)
    func presentNewTheme(_ response: Model.NewTheme.Response)
}

// MARK: - RoutingLogic
protocol SettingsRoutingLogic {
    func routeToHome()
    func routeToMore()
}
