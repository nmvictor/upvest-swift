//
//  GetUsersOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get Users Operation
internal class GetUsersOperation: GetCursorResultOperation<User> {

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - callback: UpvestCompletion ([Repository], Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                callback: @escaping UpvestCompletion<CursorResult<User>>) {
        super.init(authManager: authManager, api: api, clientId: clientId, url: "/users", callback: callback)
    }

    // we dont need auth for this operation
    override func validateOAuth() -> UpvestError? {
        return nil
    }

}
