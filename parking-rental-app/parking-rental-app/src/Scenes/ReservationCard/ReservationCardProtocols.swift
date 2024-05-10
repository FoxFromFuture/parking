//
//  ReservationCardProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

// MARK: - DisplayLogic
protocol ReservationCardDisplayLogic: AnyObject {
    typealias Model = ReservationCardModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayReservationCardInfo(_ viewModel: Model.ReservationCardInfo.ViewModel)
    func displayCreateReservation(_ viewModel: Model.CreateReservation.ViewModel)
    func displayCancelReservation(_ viewModel: Model.CancelReservation.ViewModel)
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol ReservationCardBusinessLogic {
    typealias Model = ReservationCardModel
    func loadStart(_ request: Model.Start.Request)
    func loadReservationCardInfo(_ request: Model.ReservationCardInfo.Request)
    func loadCreateReservation(_ request: Model.CreateReservation.Request)
    func loadCancelReservation(_ request: Model.CancelReservation.Request)
}

// MARK: - PresentationLogic
protocol ReservationCardPresentationLogic {
    typealias Model = ReservationCardModel
    func presentStart(_ response: Model.Start.Response)
    func presentReservationCardInfo(_ response: Model.ReservationCardInfo.Response)
    func presentCreateReservation(_ response: Model.CreateReservation.Response)
    func presentCancelReservation(_ response: Model.CancelReservation.Response)
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response)
}

// MARK: - RoutingLogic
protocol ReservationCardRoutingLogic {
    
}
