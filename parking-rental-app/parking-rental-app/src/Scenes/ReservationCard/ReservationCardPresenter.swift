//
//  ReservationCardPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

final class ReservationCardPresenter {
    // MARK: - Properties
    weak var view: ReservationCardDisplayLogic?
}

// MARK: - PresentationLogic
extension ReservationCardPresenter: ReservationCardPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentReservationCardInfo(_ response: Model.ReservationCardInfo.Response) {
        view?.displayReservationCardInfo(ReservationCardModel.ReservationCardInfo.ViewModel(parkingLotNumber: response.parkingSpot.parkingNumber, carID: response.car.id, carRegistryNumber: response.car.registryNumber, employeeID: response.car.ownerId, reservationID: response.reservationID, reservationStartTime: response.reservationStartTime, reservationEndTime: response.reservationEndTime, reservationsLimitForTime: response.reservationsLimitForTime, reservationsLimit: response.reservationsLimit, weekendLimit: response.weekendLimit))
    }
    
    func presentCreateReservation(_ response: Model.CreateReservation.Response) {
        view?.displayCreateReservation(ReservationCardModel.CreateReservation.ViewModel(reservationID: response.reservationID))
    }
    
    func presentCancelReservation(_ response: Model.CancelReservation.Response) {
        view?.displayCancelReservation(ReservationCardModel.CancelReservation.ViewModel())
    }
    
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response) {
        view?.displayLoadingFailure(ReservationCardModel.LoadingFailure.ViewModel())
    }
}
