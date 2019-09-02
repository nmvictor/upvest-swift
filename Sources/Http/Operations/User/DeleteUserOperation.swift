//
//  DeleteUserOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Delete User Operation
internal class DeleteUserOperation: BaseOperation<Void> {
    fileprivate let resource: () -> HTTPResource<Void>
    fileprivate var callback: UpvestCompletion<Void>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - username: The username
    ///   - callback: UpvestCompletion (Void, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                username: String,
                callback: @escaping UpvestCompletion<Void>) {
        self.callback = callback
        resource = {
            APIDefinition.deleteUser(username: username)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    // we dont need auth for this operation
    override func validateOAuth() -> UpvestError? {
        return nil
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
