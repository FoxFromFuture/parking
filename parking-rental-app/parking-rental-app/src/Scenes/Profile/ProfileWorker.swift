//
//  ProfileWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class ProfileWorker {
    // MARK: - Private Properties
    private let authManager = AuthManager()
}

// MARK: - WorkerLogic
extension ProfileWorker: ProfileWorkerLogic {
    func clearUserData() {
        self.authManager.deleteRefreshTokenLastUpdateDate()
        self.authManager.deleteToken(tokenType: .access)
        self.authManager.deleteToken(tokenType: .refresh)
    }
}
