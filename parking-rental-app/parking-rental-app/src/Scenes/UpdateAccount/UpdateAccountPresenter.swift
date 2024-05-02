//
//  UpdateAccountPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

final class UpdateAccountPresenter {
    // MARK: - Properties
    weak var view: UpdateAccountDisplayLogic?
}

// MARK: - PresentationLogic
extension UpdateAccountPresenter: UpdateAccountPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentAccountDetails(_ response: Model.AccountDetails.Response) {
        view?.displayAccountDetails(UpdateAccountModel.AccountDetails.ViewModel())
    }
    
    func presentUpdateAccountRequest(_ response: Model.UpdateAccountRequest.Response) {
        view?.displayUpdateAccountRequest(UpdateAccountModel.UpdateAccountRequest.ViewModel())
    }
    
    func presentUpdateAccountFailure(_ response: Model.UpdateAccountFailure.Response) {
        view?.displayUpdateAccountFailure(UpdateAccountModel.UpdateAccountFailure.ViewModel())
    }
}
