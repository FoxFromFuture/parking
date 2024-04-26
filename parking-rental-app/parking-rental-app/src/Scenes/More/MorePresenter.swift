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
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentSettings(_ response: Model.Settings.Response) {
        view?.displaySettings(MoreModel.Settings.ViewModel())
    }
    
    func presentFAQ(_ response: Model.FAQ.Response) {
        view?.displayFAQ(MoreModel.FAQ.ViewModel())
    }
}
