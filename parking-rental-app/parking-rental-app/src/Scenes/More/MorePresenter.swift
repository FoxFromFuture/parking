//
//  MorePresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

final class MorePresenter {
    // MARK: - Properties
    weak var view: MoreDisplayLogic?
}

// MARK: - PresentationLogic
extension MorePresenter: MorePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(curTheme: response.curTheme))
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentNewTheme(_ response: Model.NewTheme.Response) {
        view?.displayNewTheme(MoreModel.NewTheme.ViewModel(theme: response.theme))
    }
}
