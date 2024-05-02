//
//  ProfilePresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

final class ProfilePresenter {
    // MARK: - Properties
    weak var view: ProfileDisplayLogic?
}

// MARK: - PresentationLogic
extension ProfilePresenter: ProfilePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentAccountCars(_ response: Model.AccountCars.Response) {
        view?.displayAccountCars(Model.AccountCars.ViewModel())
    }
    
    func presentLogin(_ response: Model.Login.Response) {
        view?.displayLogin(Model.Login.ViewModel())
    }
    
    func presentAccountDetails(_ response: Model.AccountDetails.Response) {
        view?.displayAccountDetails(ProfileModel.AccountDetails.ViewModel())
    }
}
