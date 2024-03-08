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
}

// MARK: - BusinessLogic
protocol HomeBusinessLogic {
    typealias Model = HomeModel
    func loadStart(_ request: Model.Start.Request)
    func loadReservations(_ request: Model.GetReservations.Request)
}

// MARK: - PresentationLogic
protocol HomePresentationLogic {
    typealias Model = HomeModel
    func presentStart(_ response: Model.Start.Response)
    func presentReservations(_ response: Model.GetReservations.Response)
}

// MARK: - RoutingLogic
protocol HomeRoutingLogic {
//    func routeToMore()
//    func routeToProfile()
//    func routeToReservationDetails()
//    func routeToBuildings()
}

// MARK: - WorkerLogic
protocol HomeWorkerLogic {
    typealias Model = HomeModel
    func getReservations(completion: @escaping (_ reservationsData: [Reservation]?, _ error: String?) -> ())
}
