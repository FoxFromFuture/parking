//
//  UpdateAccountProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

// MARK: - DisplayLogic
protocol UpdateAccountDisplayLogic: AnyObject {
    typealias Model = UpdateAccountModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayAccountDetails(_ viewModel: Model.AccountDetails.ViewModel)
    func displayUpdateAccountRequest(_ viewModel: Model.UpdateAccountRequest.ViewModel)
    func displayUpdateAccountFailure(_ viewModel: Model.UpdateAccountFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol UpdateAccountBusinessLogic {
    typealias Model = UpdateAccountModel
    func loadStart(_ request: Model.Start.Request)
    func loadAccountDetails(_ request: Model.AccountDetails.Request)
    func loadUpdateAccountRequest(_ request: Model.UpdateAccountRequest.Request)
}

// MARK: - PresentationLogic
protocol UpdateAccountPresentationLogic {
    typealias Model = UpdateAccountModel
    func presentStart(_ response: Model.Start.Response)
    func presentAccountDetails(_ response: Model.AccountDetails.Response)
    func presentUpdateAccountRequest(_ response: Model.UpdateAccountRequest.Response)
    func presentUpdateAccountFailure(_ response: Model.UpdateAccountFailure.Response)
}

// MARK: - RoutingLogic
protocol UpdateAccountRoutingLogic {
    func routeToAccountDetails()
}
