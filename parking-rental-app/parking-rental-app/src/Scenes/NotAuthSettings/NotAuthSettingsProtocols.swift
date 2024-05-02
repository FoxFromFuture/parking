//
//  NotAuthSettingsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

// MARK: - DisplayLogic
protocol NotAuthSettingsDisplayLogic: AnyObject {
    typealias Model = NotAuthSettingsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayNewTheme(_ viewModel: Model.NewTheme.ViewModel)
    func displayNotAuthMore(_ viewModel: Model.NotAuthMore.ViewModel)
}

// MARK: - BusinessLogic
protocol NotAuthSettingsBusinessLogic {
    typealias Model = NotAuthSettingsModel
    func loadStart(_ request: Model.Start.Request)
    func loadNewTheme(_ request: Model.NewTheme.Request)
    func loadNotAuthMore(_ request: Model.NotAuthMore.Request)
}

// MARK: - PresentationLogic
protocol NotAuthSettingsPresentationLogic {
    typealias Model = NotAuthSettingsModel
    func presentStart(_ response: Model.Start.Response)
    func presentNewTheme(_ response: Model.NewTheme.Response)
    func presentNotAuthMore(_ response: Model.NotAuthMore.Response)
}

// MARK: - RoutingLogic
protocol NotAuthSettingsRoutingLogic {
    func routeToNotAuthMore()
}
