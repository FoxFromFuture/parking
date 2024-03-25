//
//  BuildingsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

// MARK: - DisplayLogic
protocol BuildingsDisplayLogic: AnyObject {
    typealias Model = BuildingsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayBuildings(_ viewModel: Model.GetBuildings.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayMap(_ viewModel: Model.Map.ViewModel)
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol BuildingsBusinessLogic {
    typealias Model = BuildingsModel
    func loadStart(_ request: Model.Start.Request)
    func loadBuildings(_ request: Model.GetBuildings.Request)
    func loadMore(_ request: Model.More.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadMap(_ request: Model.Map.Request)
}

// MARK: - PresentationLogic
protocol BuildingsPresentationLogic {
    typealias Model = BuildingsModel
    func presentStart(_ response: Model.Start.Response)
    func presentBuildings(_ response: Model.GetBuildings.Response)
    func presentMore(_ response: Model.More.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentMap(_ response: Model.Map.Response)
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response)
}

// MARK: - RoutingLogic
protocol BuildingsRoutingLogic {
    func routeToMore()
    func routeToHome()
    func routeToMap()
}

// MARK: - WorkerLogic
protocol BuildingsWorkerLogic {
    typealias Model = BuildingsModel
    func getAllBuildings(completion: @escaping (_ buildingsData: [Building]?, _ error: String?) -> ())
}
