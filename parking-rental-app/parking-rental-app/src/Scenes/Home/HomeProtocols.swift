//
//  HomeProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

// MARK: - DisplayLogic
protocol HomeDisplayLogic: AnyObject {
    typealias Model = HomeModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayReservations(_ viewModel: Model.GetReservations.ViewModel)
    func displayBuildings(_ viewModel: Model.Buildings.ViewModel)
    func displayMap(_ viewModel: Model.Map.ViewModel)
    func displayProfile(_ viewModel: Model.Profile.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel)
    func displayNoData(_ viewModel: Model.NoData.ViewModel)
}

// MARK: - BusinessLogic
protocol HomeBusinessLogic {
    typealias Model = HomeModel
    func loadStart(_ request: Model.Start.Request)
    func loadReservations(_ request: Model.GetReservations.Request)
    func loadBuildings(_ request: Model.Buildings.Request)
    func loadMap(_ request: Model.Map.Request)
    func loadProfile(_ request: Model.Profile.Request)
    func loadMore(_ request: Model.More.Request)
}

// MARK: - PresentationLogic
protocol HomePresentationLogic {
    typealias Model = HomeModel
    func presentStart(_ response: Model.Start.Response)
    func presentReservations(_ response: Model.GetReservations.Response)
    func presentBuildings(_ response: Model.Buildings.Response)
    func presentMap(_ response: Model.Map.Response)
    func presentProfile(_ response: Model.Profile.Response)
    func presentMore(_ response: Model.More.Response)
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response)
    func presentNoData(_ response: Model.NoData.Response)
}

// MARK: - RoutingLogic
protocol HomeRoutingLogic {
    func routeToBuildings()
    func routeToMap()
    func routeToProfile()
    func routeToMore()
}

// MARK: - WorkerLogic
protocol HomeWorkerLogic {
    typealias Model = HomeModel
    func getAllReservations(completion: @escaping (_ reservationsData: [Reservation]?, _ error: String?) -> ())
    func getAllParkingSpots(completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: String?) -> ())
    func getAllParkingLevels(completion: @escaping (_ parkingLevelsData: [ParkingLevel]?, _ error: String?) -> ())
    func getAllBuildings(completion: @escaping (_ buildingsData: [Building]?, _ error: String?) -> ())
}
