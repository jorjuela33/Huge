//
//  AuthToken.swift
//  Application
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Foundation

private var accessToken: AccessToken?

struct AccessToken {
    let tokenString: String

    // MARK: Initializers

    init(tokenString: String) {
        self.tokenString = tokenString
    }

    // MARK: Class methods

    static func currentAccessToken() -> AccessToken? {
        return accessToken
    }

    static func setCurrentAccessToken(_ token: AccessToken) {
        guard token.tokenString != accessToken?.tokenString else { return }

        accessToken = token
    }
}
