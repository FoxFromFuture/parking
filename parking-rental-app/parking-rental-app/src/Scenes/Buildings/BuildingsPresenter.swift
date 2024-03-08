//
//  BuildingsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

final class BuildingsPresenter {
    // MARK: - Properties
    weak var view: BuildingsDisplayLogic?
}

// MARK: - PresentationLogic
extension BuildingsPresenter: BuildingsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
