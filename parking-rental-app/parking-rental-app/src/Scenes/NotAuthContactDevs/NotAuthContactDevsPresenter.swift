//
//  NotAuthContactDevsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

final class NotAuthContactDevsPresenter {
    // MARK: - Properties
    weak var view: NotAuthContactDevsDisplayLogic?
}

// MARK: - PresentationLogic
extension NotAuthContactDevsPresenter: NotAuthContactDevsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentNotAuthMore(_ response: Model.NotAuthMore.Response) {
        view?.displayNotAuthMore(NotAuthContactDevsModel.NotAuthMore.ViewModel())
    }
    
    func presentGitHubLink(_ response: Model.GitHubLink.Response) {
        view?.displayGitHubLink(NotAuthContactDevsModel.GitHubLink.ViewModel())
    }
}
