//
//  FAQPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

final class FAQPresenter {
    // MARK: - Properties
    weak var view: FAQDisplayLogic?
}

// MARK: - PresentationLogic
extension FAQPresenter: FAQPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(Model.More.ViewModel())
    }
}
