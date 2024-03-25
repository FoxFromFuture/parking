//
//  MapPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

final class MapPresenter {
    // MARK: - Properties
    weak var view: MapDisplayLogic?
}

// MARK: - PresentationLogic
extension MapPresenter: MapPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentParkingMap(_ response: Model.ParkingMap.Response) {
        var parkingSpotsCoords: [OnCanvasCoords] = []
        var parkingSpotsCanvases: [Canvas] = []
        
        for parkingSpot in response.parkingSpots {
            parkingSpotsCoords.append(parkingSpot.onCanvasCoords)
            parkingSpotsCanvases.append(parkingSpot.canvas)
        }
        
        view?.displayParkingMap(MapModel.ParkingMap.ViewModel(parkingSpotsCoords: parkingSpotsCoords, parkingSpotsCanvases: parkingSpotsCanvases, parkingLevelCanvas: response.parkingLevelCanvas))
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(MapModel.Home.ViewModel()     )
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(MapModel.More.ViewModel())
    }
    
    func presentPreviousScene(_ response: Model.PreviousScene.Response) {
        view?.displayPreviousScene(MapModel.PreviousScene.ViewModel())
    }
}
