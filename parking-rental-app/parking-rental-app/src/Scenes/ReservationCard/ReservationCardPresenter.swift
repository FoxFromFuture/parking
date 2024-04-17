//
//  ReservationCardPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

import Foundation

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
        
        var startTime: String?
        var endTime: String?
        var date: String?

        if let resStartTime = response.reservationStartTime, let resEndTime = response.reservationEndTime {
            startTime = "\(resStartTime.prefix(16).suffix(5))"
            endTime = "\(resEndTime.prefix(16).suffix(5))"
            date = "\(resStartTime.prefix(10))"
        } else {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            timeFormatter.timeZone = .current
            
            startTime = timeFormatter.string(from: response.startTime)
            endTime = timeFormatter.string(from: response.endTime)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = .current
            
            date = dateFormatter.string(from: response.startTime)
        }
        
        if let startTime = startTime, let endTime = endTime, let date = date {
            view?.displayReservationCardInfo(ReservationCardModel.ReservationCardInfo.ViewModel(parkingLotNumber: response.parkingSpot.parkingNumber, carID: response.car.id, carRegistryNumber: response.car.registryNumber, employeeID: response.car.ownerId, reservationID: response.reservationID, reservationsLimitForTime: response.reservationsLimitForTime, reservationsLimit: response.reservationsLimit, weekendLimit: response.weekendLimit, startTime: startTime, endTime: endTime, date: date))
        }
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
