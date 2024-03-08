//
//  LoginPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

final class LoginPresenter {
    // MARK: - Properties
    weak var view: LoginDisplayLogic?
}

// MARK: - PresentationLogic
extension LoginPresenter: LoginPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentRegistration(_ response: Model.Registration.Response) {
        view?.displayRegistration(Model.Registration.ViewModel())
    }
}
