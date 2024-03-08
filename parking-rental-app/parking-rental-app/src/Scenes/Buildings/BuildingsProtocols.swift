//
//  BuildingsProtocols.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

// MARK: - DisplayLogic
protocol BuildingsDisplayLogic: AnyObject {
    typealias Model = BuildingsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
}

// MARK: - BusinessLogic
protocol BuildingsBusinessLogic {
    typealias Model = BuildingsModel
    func loadStart(_ request: Model.Start.Request)
}

// MARK: - PresentationLogic
protocol BuildingsPresentationLogic {
    typealias Model = BuildingsModel
    func presentStart(_ response: Model.Start.Response)
}

// MARK: - RoutingLogic
protocol BuildingsRoutingLogic {

}

// MARK: - WorkerLogic
protocol BuildingsWorkerLogic {
    typealias Model = BuildingsModel

}
