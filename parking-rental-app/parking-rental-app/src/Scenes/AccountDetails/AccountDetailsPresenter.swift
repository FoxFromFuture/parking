//
//  AccountDetailsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

final class AccountDetailsPresenter {
    // MARK: - Properties
    weak var view: AccountDetailsDisplayLogic?
}

// MARK: - PresentationLogic
extension AccountDetailsPresenter: AccountDetailsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentProfile(_ response: Model.Profile.Response) {
        view?.displayProfile(AccountDetailsModel.Profile.ViewModel())
    }
    
    func presentUserDetails(_ response: Model.UserDetails.Response) {
        view?.displayUserDetails(AccountDetailsModel.UserDetails.ViewModel(name: response.user.name, email: response.user.email))
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(AccountDetailsModel.More.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(AccountDetailsModel.Home.ViewModel())
    }
    
    func presentLogin(_ response: Model.Login.Response) {
        view?.displayLogin(AccountDetailsModel.Login.ViewModel())
    }
    
    func presentUpdateAccount(_ response: Model.UpdateAccount.Response) {
        view?.displayUpdateAccount(AccountDetailsModel.UpdateAccount.ViewModel())
    }
    
    func presentUpdateAccountFailure(_ response: Model.UpdateAccountFailure.Response) {
        view?.displayUpdateAccountFailure(AccountDetailsModel.UpdateAccountFailure.ViewModel())
    }
}
