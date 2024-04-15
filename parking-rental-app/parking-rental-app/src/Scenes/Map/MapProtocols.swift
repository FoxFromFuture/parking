//
//  MapProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

// MARK: - DisplayLogic
protocol MapDisplayLogic: AnyObject {
    typealias Model = MapModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayParkingMap(_ viewModel: Model.ParkingMap.ViewModel)
    func displayHome(_ viewModel: Model.Home.ViewModel)
    func displayMore(_ viewModel: Model.More.ViewModel)
    func displayPreviousScene(_ viewModel: Model.PreviousScene.ViewModel)
    func displayReloadedMap(_ viewModel: Model.ReloadMap.ViewModel)
    func displayReservationCard(_ viewModel: Model.ReservationCard.ViewModel)
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel)
    func displayReloadingFailure(_ viewModel: Model.ReloadingFailure.ViewModel)
}

// MARK: - BusinessLogic
protocol MapBusinessLogic {
    typealias Model = MapModel
    func loadStart(_ request: Model.Start.Request)
    func loadParkingMap(_ request: Model.ParkingMap.Request)
    func loadHome(_ request: Model.Home.Request)
    func loadMore(_ request: Model.More.Request)
    func loadPreviousScene(_ request: Model.PreviousScene.Request)
    func loadReloadedMap(_ request: Model.ReloadMap.Request)
    func loadReservationCard(_ request: Model.ReservationCard.Request)
}

// MARK: - PresentationLogic
protocol MapPresentationLogic {
    typealias Model = MapModel
    func presentStart(_ response: Model.Start.Response)
    func presentParkingMap(_ response: Model.ParkingMap.Response)
    func presentHome(_ response: Model.Home.Response)
    func presentMore(_ response: Model.More.Response)
    func presentPreviousScene(_ response: Model.PreviousScene.Response)
    func presentReloadedMap(_ response: Model.ReloadMap.Response)
    func presentReservationCard(_ response: Model.ReservationCard.Response)
    func presentLoadingFailure(_ response: Model.LoadingFailure.Response)
    func presentReloadingFailure(_ response: Model.ReloadingFailure.Response)
}

// MARK: - RoutingLogic
protocol MapRoutingLogic {
    typealias Model = MapModel
    func routeToHome()
    func routeToMore()
    func routeToPreviousScene()
    func routeToReservationCard(_ routeData: Model.ReservationCard.RouteData)
}

// MARK: - WorkerLogic
protocol MapWorkerLogic {
    typealias Model = MapModel
    func getAllBuildingLevels(buildingID: String, completion: @escaping (_ levelsData: [ParkingLevel]?, _ error: String?) -> ())
    func getAllLevelSpots(parkingLevelID: String, completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: String?) -> ())
    func getAllLevelFreeSpots(parkingLevelID: String, startTime: String, endTime: String, completion: @escaping (_ parkingSpotsData: [ParkingSpot]?, _ error: String?) -> ())
    func getAllReservations(completion: @escaping (_ reservationsData: [Reservation]?, _ error: String?) -> ())
    func getBuilding(buildingID: String, completion: @escaping (_ buildingData: Building?, _ error: String?) -> ())
    func getReservation(reservationID: String, completion: @escaping (_ reservationData: Reservation?, _ error: String?) -> ())
    func getParkingSpot(parkingSpotID: String, completion: @escaping (_ parkingSpotData: ParkingSpot?, _ error: String?) -> ())
    func getParkingLevel(parkingLevelID: String, completion: @escaping (_ parkingLevelData: ParkingLevel?, _ error: String?) -> ())
}
