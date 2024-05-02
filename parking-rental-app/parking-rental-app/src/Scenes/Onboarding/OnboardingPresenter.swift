//
//  OnboardingPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/1/24.
//

final class OnboardingPresenter {
    // MARK: - Properties
    weak var view: OnboardingDisplayLogic?
}

// MARK: - PresentationLogic
extension OnboardingPresenter: OnboardingPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentHome(_ response: Model.Home.Response) {
        view?.displayHome(OnboardingModel.Home.ViewModel())
    }
}
