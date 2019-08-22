//
//  ClienteleAPI.swift
//  UpvestTests
//
//  Created by Moin' Victor on 21/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Clientele API
public class ClienteleAPI {
    internal let clientId: String
    internal let clientSecret: String
    internal let scope: String
    internal var authManager: AuthManager
    internal var api: UpvestAPIType

    /// New Clientele API
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

    ///////////////////////////////////////////// OPERATIONS /////////////////////////////////////////////

    func authenticate(username: String, password: String, callback: UpvestCompletion<UpvestOAuth>? = nil) {
        Upvest.submit(operation: AuthOperation(authManager: authManager, api: api, clientId: self.clientId, clientSecret: self.clientSecret, scope: self.scope, username: username, password: password, callback: callback))
    }

    /// Echo from Clientele API using `GET`
    ///
    /// - Parameters:
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion<Echo> callback
    func getEcho(echo: String, callback: @escaping UpvestCompletion<Echo>) {
        Upvest.submit(operation: GetClienteleEchoOperation(authManager: self.authManager, api: api, clientId: self.clientId, echo: echo, callback: callback))
    }

    /// Echo from Clientele API using `POST`
    ///
    /// - Parameters:
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion<Echo> callback
    func postEcho(echo: String, callback: @escaping UpvestCompletion<Echo>) {
        Upvest.submit(operation: PostClienteleEchoOperation(authManager: self.authManager, api: api, clientId: self.clientId, echo: echo, callback: callback))
    }

}
