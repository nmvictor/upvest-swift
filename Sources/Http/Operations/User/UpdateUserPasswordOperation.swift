//
//  UpdateUserPasswordOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Update User Password Operation.
internal class UpdateUserPasswordOperation: BaseOperation<User> {
    fileprivate let resource: () -> HTTPResource<User>
    fileprivate var callback: UpvestCompletion<User>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - username: The username
    ///   - oldPassword: The old password
    ///   - newPassword: The new password
    ///   - callback: UpvestCompletion (User, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                username: String,
                oldPassword: String,
                newPassword: String,
                callback: @escaping UpvestCompletion<User>) {
        self.callback = callback
        resource = {
            APIDefinition.updateUserPassword(username: username, oldPassword: oldPassword, newPassword: newPassword)
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
