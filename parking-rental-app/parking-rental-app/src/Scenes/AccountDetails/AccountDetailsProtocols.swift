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
    func displayLogin(_ viewModel: Model.Login.ViewModel)
    func displayUpdateAccount(_ viewModel: Model.UpdateAccount.ViewModel)
    func displayUpdateAccountFailure(_ viewModel: Model.UpdateAccountFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol AccountDetailsBusinessLogic {
    typealias Model = AccountDetailsModel
    func loadStart(_ request: Model.Start.Request)
    func loadProfile(_ request: Model.Profile.Request)
    func loadUserDetails(_ request: Model.UserDetails.Request)
    func loadLogin(_ request: Model.Login.Request)
    func loadUpdateAccount(_ request: Model.UpdateAccount.Request)
}

// MARK: - PresentationLogic
protocol AccountDetailsPresentationLogic {
    typealias Model = AccountDetailsModel
    func presentStart(_ response: Model.Start.Response)
    func presentProfile(_ response: Model.Profile.Response)
    func presentUserDetails(_ response: Model.UserDetails.Response)
    func presentLogin(_ response: Model.Login.Response)
    func presentUpdateAccount(_ response: Model.UpdateAccount.Response)
    func presentUpdateAccountFailure(_ response: Model.UpdateAccountFailure.Response)
}

// MARK: - RoutingLogic
protocol AccountDetailsRoutingLogic {
    func routeToProfile()
    func routeToLogin()
    func routeToUpdateAccount()
}
