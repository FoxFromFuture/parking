//
//  SplashPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

final class SplashPresenter {
    // MARK: - Properties
    weak var view: SplashDisplayLogic?
}

// MARK: - PresentationLogic
extension SplashPresenter: SplashPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentLogin(_ response: Model.Login.Response) {
        view?.displayLogin(Model.Login.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
}
