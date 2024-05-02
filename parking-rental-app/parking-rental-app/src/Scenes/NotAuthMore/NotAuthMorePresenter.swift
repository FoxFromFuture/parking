//
//  NotAuthMorePresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/29/24.
//

final class NotAuthMorePresenter {
    // MARK: - Properties
    weak var view: NotAuthMoreDisplayLogic?
}

// MARK: - PresentationLogic
extension NotAuthMorePresenter: NotAuthMorePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentNotAuthSettings(_ response: Model.NotAuthSettings.Response) {
        view?.displayNotAuthSettings(NotAuthMoreModel.NotAuthSettings.ViewModel())
    }
    
    func presentNotAuthContactDevs(_ response: Model.NotAuthContactDevs.Response) {
        view?.displayNotAuthContactDevs(NotAuthMoreModel.NotAuthContactDevs.ViewModel())
    }
}
