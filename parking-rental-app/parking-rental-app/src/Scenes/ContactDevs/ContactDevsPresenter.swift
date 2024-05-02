//
//  ContactDevsPresenter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/27/24.
//

final class ContactDevsPresenter {
    // MARK: - Properties
    weak var view: ContactDevsDisplayLogic?
}

// MARK: - PresentationLogic
extension ContactDevsPresenter: ContactDevsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentMore(_ response: Model.More.Response) {
        view?.displayMore(ContactDevsModel.More.ViewModel())
    }
    
    func presentGitHubLink(_ response: Model.GitHubLink.Response) {
        view?.displayGitHubLink(ContactDevsModel.GitHubLink.ViewModel())
    }
}
