//
//  BuildingsWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

final class BuildingsWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
}

// MARK: - WorkerLogic
extension BuildingsWorker: BuildingsWorkerLogic {
    func getAllBuildings(completion: @escaping (_ buildingsData: [Building]?, _ error: String?) -> ()) {
        networkManager.getAllBuildings { buildingsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = buildingsData {
                completion(data, nil)
            }
        }
    }
}
