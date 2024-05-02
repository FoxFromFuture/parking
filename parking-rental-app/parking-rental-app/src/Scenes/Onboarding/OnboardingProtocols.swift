//
//  OnboardingProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/1/24.
//

// MARK: - DisplayLogic
protocol OnboardingDisplayLogic: AnyObject {
    typealias Model = OnboardingModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
}

// MARK: - BusinessLogic
protocol OnboardingBusinessLogic {
    typealias Model = OnboardingModel
    func loadStart(_ request: Model.Start.Request)
    func loadHome(_ request: Model.Home.Request)
}

// MARK: - PresentationLogic
protocol OnboardingPresentationLogic {
    typealias Model = OnboardingModel
    func presentStart(_ response: Model.Start.Response)
    func presentHome(_ response: Model.Home.Response)
}

// MARK: - RoutingLogic
protocol OnboardingRoutingLogic {
    func routeToHome()
}
