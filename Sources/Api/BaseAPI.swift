//
//  BaseAPI.swift
//  Upvest
//
//  Created by Moin' Victor on 28/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Base API
public class BaseAPI {
    internal let clientId: String
    internal let clientSecret: String
    internal let scope: String
    internal var authManager: AuthManager
    internal var api: UpvestAPIType

    /// New API
    ///
    /// - Parameters:
    ///   - authManager: Auth Manager
    ///   - api: API object
    ///   - clientId: Client ID
    ///   - clientSecret: Client secret
    ///   - scope: Scope
    internal init(authManager: AuthManager, api: UpvestAPIType, clientId: String, clientSecret: String, scope: String) {
        self.authManager = authManager
        self.api = api
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.scope = scope
    }

    internal func allowOAuth() -> Bool {
        return true
    }

    /// Cursor for result
    ///
    /// - Parameter result: CursorResult<T>
    /// - Returns: APICursor<T>
    public func cursor<T: Codable>(_ result: CursorResult<T>) -> APICursor<T> {
        return APICursor(from: result, authManager: self.authManager, api: self.api, clientId: self.clientId, clientSecret: self.clientSecret, scope: self.scope, allowOAuth: allowOAuth())
    }

}
