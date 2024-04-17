//
//  AccountDetailsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

// MARK: - DisplayLogic
protocol AccountDetailsDisplayLogic: AnyObject {
    typealias Model = AccountDetailsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayProfile(_ viewModel: Model.Profile.ViewModel)
    func displayUserDetails(_ viewModel: Model.UserDetails.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayLogin(_ viewModel: Model.Login.ViewModel)
}

// MARK: - BusinessLogic
protocol AccountDetailsBusinessLogic {
    typealias Model = AccountDetailsModel
    func loadStart(_ request: Model.Start.Request)
    func loadProfile(_ request: Model.Profile.Request)
    func loadUserDetails(_ request: Model.UserDetails.Request)
    func loadMore(_ request: Model.More.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadLogin(_ request: Model.Login.Request)
}

// MARK: - PresentationLogic
protocol AccountDetailsPresentationLogic {
    typealias Model = AccountDetailsModel
    func presentStart(_ response: Model.Start.Response)
    func presentProfile(_ response: Model.Profile.Response)
    func presentUserDetails(_ response: Model.UserDetails.Response)
    func presentMore(_ response: Model.More.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentLogin(_ response: Model.Login.Response)
}

// MARK: - RoutingLogic
protocol AccountDetailsRoutingLogic {
    func routeToProfile()
    func routeToMore()
    func routeToHome()
    func routeToLogin()
}
