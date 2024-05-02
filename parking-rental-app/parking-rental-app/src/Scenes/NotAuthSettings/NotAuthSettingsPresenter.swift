//
//  NotAuthSettingsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

final class NotAuthSettingsPresenter {
    // MARK: - Properties
    weak var view: NotAuthSettingsDisplayLogic?
}

// MARK: - PresentationLogic
extension NotAuthSettingsPresenter: NotAuthSettingsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(curTheme: response.curTheme))
    }
    
    func presentNewTheme(_ response: Model.NewTheme.Response) {
        view?.displayNewTheme(Model.NewTheme.ViewModel(theme: response.theme))
    }
    
    func presentNotAuthMore(_ response: Model.NotAuthMore.Response) {
        view?.displayNotAuthMore(NotAuthSettingsModel.NotAuthMore.ViewModel())
    }
}
