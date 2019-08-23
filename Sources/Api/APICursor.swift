//
//  APICursor.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Class to interate result from API
public class APICursor<T: Codable> {

    internal let result: CursorResult<T>
    internal let clientId: String
    internal let clientSecret: String
    internal let scope: String
    internal var authManager: AuthManager
    internal var api: UpvestAPIType

    /// New API Cursor
    ///
    /// - Parameters:
    ///   - authManager: Auth Manager
    ///   - api: API object
    ///   - clientId: Client ID
    ///   - clientSecret: Client secret
    ///   - scope: Scope
    internal init(from result: CursorResult<T>, authManager: AuthManager, api: UpvestAPIType, clientId: String, clientSecret: String, scope: String) {
        self.result = result
        self.authManager = authManager
        self.api = api
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.scope = scope
    }

    /// Previous items in this cursor
    ///
    /// - Parameter callback: UpvestCompletion<CursorResult<T>>
    func previous(_ callback: @escaping UpvestCompletion<CursorResult<T>>) {
        guard let previous = self.result.previous else {
            callback(.success(result))
            return
        }
        Upvest.submit(operation: GetCursorResultOperation(authManager: self.authManager, api: self.api, clientId: self.clientId, url: previous, callback: callback))
    }

    /// Next items in this cursor
    ///
    /// - Parameter callback: UpvestCompletion<CursorResult<T>>
    func next(_ callback: @escaping UpvestCompletion<CursorResult<T>>) {
        guard let next = self.result.next else {
            callback(.success(result))
            return
        }
        Upvest.submit(operation: GetCursorResultOperation(authManager: self.authManager, api: self.api, clientId: self.clientId, url: next, callback: callback))
    }
}
