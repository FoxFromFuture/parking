//
//  HomePresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

final class HomePresenter {
    // MARK: - Properties
    weak var view: HomeDisplayLogic?
}

// MARK: - PresentationLogic
extension HomePresenter: HomePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentReservations(_ response: Model.GetReservations.Response) {
        /// Prepare datastores
        var dates: [String] = []
        var startTimes: [String] = []
        var endTimes: [String] = []
        var lotNumbers: [String] = []
        var levelNumbers: [String] = []
        var buildingNames: [String] = []
        var reservationsIDx: [String] = []
    
        /// Retrieve "dates", "start times" and "end times" from reservations
        for reservation in response.reservations {
            dates.append("\(reservation.startTime.prefix(10))")
            startTimes.append("\(reservation.startTime.suffix(8).prefix(5))")
            endTimes.append("\(reservation.endTime.suffix(8).prefix(5))")
            reservationsIDx.append(reservation.id)
            for parkingSpot in response.parkingSpots {
                if parkingSpot.id == reservation.parkingSpotId {
                    lotNumbers.append(parkingSpot.parkingNumber)
                    
                    /// Find corresponding parking level
                    for parkingLevel in response.parkingLevels {
                        if parkingSpot.levelId == parkingLevel.id {
                            levelNumbers.append("\(parkingLevel.levelNumber)")
                            break
                        }
                    }
                    
                    /// Find corresponding building
                    for building in response.buildings {
                        if parkingSpot.buildingId == building.id {
                            buildingNames.append(building.name)
                            break
                        }
                    }
                }
            }
        }
        
        view?.displayReservations(Model.GetReservations.ViewModel(reservationsCount: response.reservations.count, dates: dates, startTimes: startTimes, endTimes: endTimes, lotNumbets: lotNumbers, levelNumbers: levelNumbers, buildingNames: buildingNames, reservationsIDx: reservationsIDx))
    }
    
    func presentBuildings(_ response: Model.Buildings.Response) {
        view?.displayBuildings(Model.Buildings.ViewModel())
    }
    
    func presentMap(_ response: Model.Map.Response) {
        view?.displayMap(Model.Map.ViewModel(reservationID: response.reservationID))
    }
    
    func presentProfile(_ response: Model.Profile.Response) {
        view?.displayProfile(Model.Profile.ViewModel())
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(Model.More.ViewModel())
    }
    
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response) {
        view?.displayLoadingFailure(Model.LoadingFailure.ViewModel())
    }
    
    func presentNoData(_ response: Model.NoData.Response) {
        view?.displayNoData(HomeModel.NoData.ViewModel())
    }
}
