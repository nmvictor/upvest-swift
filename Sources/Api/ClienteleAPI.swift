//
//  ClienteleAPI.swift
//  UpvestTests
//
//  Created by Moin' Victor on 21/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Clientele API
public class ClienteleAPI: BaseAPI {

    ///////////////////////////////////////////// OPERATIONS /////////////////////////////////////////////

    /// Authenticate User
    ///
    /// - Parameters:
    ///   - username: Username
    ///   - password: Password
    ///   - callback: UpvestCompletion<UpvestOAuth> callback
    public func authenticate(username: String, password: String, callback: UpvestCompletion<UpvestOAuth>? = nil) {
        Upvest.submit(operation: AuthOperation(authManager: authManager, api: api, clientId: self.clientId, clientSecret: self.clientSecret, scope: self.scope, username: username, password: password, callback: callback))
    }

    /// Echo from Clientele API using `GET`
    ///
    /// - Parameters:
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion<Echo> callback
    public func getEcho(echo: String, callback: @escaping UpvestCompletion<Echo>) {
        Upvest.submit(operation: GetOAuth2EchoOperation(authManager: self.authManager, api: api, clientId: self.clientId, echo: echo, callback: callback))
    }

    /// Echo from Clientele API using `POST`
    ///
    /// - Parameters:
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion<Echo> callback
    public func postEcho(echo: String, callback: @escaping UpvestCompletion<Echo>) {
        Upvest.submit(operation: PostOAuth2EchoOperation(authManager: self.authManager, api: api, clientId: self.clientId, echo: echo, callback: callback))
    }

}
