//
//  ResetUserPasswordOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Reset User Password Operation.
internal class ResetUserPasswordOperation: BaseOperation<BasicResult> {
    fileprivate let resource: () -> HTTPResource<BasicResult>
    fileprivate var callback: UpvestCompletion<BasicResult>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - username: The username
    ///   - userId: The user id
    ///   - seed: The seed configuration, from the decrypted recovery kit.
    ///   - seedHash: The hash of the seed.
    ///   - newPassword: The new password for the user
    ///   - callback: UpvestCompletion (Result, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                username: String,
                userId: String,
                seed: String,
                seedHash: String,
                newPassword: String,
                callback: @escaping UpvestCompletion<BasicResult>) {
        self.callback = callback
        resource = {
            APIDefinition.resetUserPassword(username: username, userId: userId, seed: seed, seedHash: seedHash, newPassword: newPassword)
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
