//
//  SettingsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

final class SettingsPresenter {
    // MARK: - Properties
    weak var view: SettingsDisplayLogic?
}

// MARK: - PresentationLogic
extension SettingsPresenter: SettingsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(curTheme: response.curTheme))
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(Model.Home.ViewModel())
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(SettingsModel.More.ViewModel())
    }
    
    func presentNewTheme(_ response: Model.NewTheme.Response) {
        view?.displayNewTheme(Model.NewTheme.ViewModel(theme: response.theme))
    }
}
