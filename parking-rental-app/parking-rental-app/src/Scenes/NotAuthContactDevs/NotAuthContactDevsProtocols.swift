//
//  NotAuthContactDevsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

// MARK: - DisplayLogic
protocol NotAuthContactDevsDisplayLogic: AnyObject {
    typealias Model = NotAuthContactDevsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayNotAuthMore(_ viewModel: Model.NotAuthMore.ViewModel)
    func displayGitHubLink(_ viewModel: Model.GitHubLink.ViewModel)
}

// MARK: - BusinessLogic
protocol NotAuthContactDevsBusinessLogic {
    typealias Model = NotAuthContactDevsModel
    func loadStart(_ request: Model.Start.Request)
    func loadNotAuthMore(_ request: Model.NotAuthMore.Request)
    func loadGitHubLink(_ request: Model.GitHubLink.Request)
}

// MARK: - PresentationLogic
protocol NotAuthContactDevsPresentationLogic {
    typealias Model = NotAuthContactDevsModel
    func presentStart(_ response: Model.Start.Response)
    func presentNotAuthMore(_ response: Model.NotAuthMore.Response)
    func presentGitHubLink(_ response: Model.GitHubLink.Response)
}

// MARK: - RoutingLogic
protocol NotAuthContactDevsRoutingLogic {
    func routeToNotAuthMore()
    func routeToGitHubLink()
}
