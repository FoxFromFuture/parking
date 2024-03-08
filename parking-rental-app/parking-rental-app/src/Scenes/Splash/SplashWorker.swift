//
//  SplashWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import UIKit

final class SplashWorker {
    // MARK: - Private Properties
    private let authManager = AuthManager.shared
}

// MARK: - WorkerLogic
extension SplashWorker: SplashWorkerLogic {
    func wasUserLogined() -> Bool {
        guard let _ = authManager.getRefreshToken() else { return false }
        return true
    }
}
