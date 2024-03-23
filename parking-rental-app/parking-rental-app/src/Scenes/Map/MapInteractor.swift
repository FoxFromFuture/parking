//
//  MapInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MapInteractor {
    // MARK: - Private Properties
    private let presenter: MapPresentationLogic
    private let worker: MapWorkerLogic
    
    // MARK: - Initializers
    init(presenter: MapPresentationLogic, worker: MapWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension MapInteractor: MapBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(MapModel.Home.Response())
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(MapModel.More.Response())
    }
    
    func loadPreviousScene(_ request: Model.PreviousScene.Request) {
        presenter.presentPreviousScene(MapModel.PreviousScene.Response())
    }
}
