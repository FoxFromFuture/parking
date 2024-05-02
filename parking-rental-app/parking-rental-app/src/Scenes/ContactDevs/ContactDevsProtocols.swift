//
//  ContactDevsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/27/24.
//

// MARK: - DisplayLogic
protocol ContactDevsDisplayLogic: AnyObject {
    typealias Model = ContactDevsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayGitHubLink(_ viewModel: Model.GitHubLink.ViewModel)
}

// MARK: - BusinessLogic
protocol ContactDevsBusinessLogic {
    typealias Model = ContactDevsModel
    func loadStart(_ request: Model.Start.Request)
    func loadMore(_ request: Model.More.Request)
    func loadGitHubLink(_ request: Model.GitHubLink.Request)
}

// MARK: - PresentationLogic
protocol ContactDevsPresentationLogic {
    typealias Model = ContactDevsModel
    func presentStart(_ response: Model.Start.Response)
    func presentMore(_ response: Model.More.Response)
    func presentGitHubLink(_ response: Model.GitHubLink.Response)
}

// MARK: - RoutingLogic
protocol ContactDevsRoutingLogic {
    func routeToMore()
    func routeToGitHubLink()
}
