//
//  SplashWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import UIKit

final class SplashWorker {
    // MARK: - Private Properties
    private let authManager = AuthManager()
    private let networkManager = NetworkManager()
}

// MARK: - WorkerLogic
extension SplashWorker: SplashWorkerLogic {
    func wasUserLogined() -> Bool {
        guard let _ = authManager.getRefreshToken() else { return false }
        return true
    }
    
    func tryUpdateRefreshToken(completion: @escaping (AuthApiResponse?, String?) -> ()) {
        self.networkManager.updateRefreshToken { [weak self] authData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = authData {
                if !(self?.authManager.updateToken(token: data.refreshToken, tokenType: .refresh) ?? false) {
                    completion(nil, "Update Token Error")
                }
                completion(data, nil)
            }
        }
    }
}
