//
//  TenancyAPI.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Tenancy API
public class TenancyAPI: BaseAPI {

    override func allowOAuth() -> Bool {
        return false
    }

    ///////////////////////////////////////////// OPERATIONS /////////////////////////////////////////////

    /// Create User
    ///
    /// - Parameters:
    ///   - username: The username
    ///   - callback: UpvestCompletion (User, Error?)
    public func createUser(username: String, _ callback: @escaping UpvestCompletion<User>) {
        Upvest.submit(operation: CreateUserOperation(authManager: self.authManager, api: api, clientId: self.clientId, username: username, callback: callback))
    }

    /// Delete User
    ///
    /// - Parameters:
    ///   - username: The username
    ///   - callback: UpvestCompletion (Void, Error?)
    public func deleteUser(username: String, _ callback: @escaping UpvestCompletion<Void>) {
        Upvest.submit(operation: DeleteUserOperation(authManager: self.authManager, api: api, clientId: self.clientId, username: username, callback: callback))
    }

    /// Update User Password
    ///
    /// - Parameters:
    ///   - username: The username
    ///   - oldPassword: The old password
    ///   - newPassword: The new password
    ///   - callback: UpvestCompletion (User, Error?)
    public func updateUserPassword(username: String,
                                   oldPassword: String,
                                   newPassword: String, _ callback: @escaping UpvestCompletion<User>) {
        Upvest.submit(operation: UpdateUserPasswordOperation(authManager: self.authManager, api: api, clientId: self.clientId, username: username, oldPassword: oldPassword, newPassword: newPassword, callback: callback))
    }

    /// Reset User Password
    ///
    /// - Parameters:
    ///   - username: The username
    ///   - userId: The user id
    ///   - seed: The seed configuration, from the decrypted recovery kit.
    ///   - seedHash: The hash of the seed.
    ///   - newPassword: The new password for the user
    ///   - callback: UpvestCompletion (BasicResult, Error?)
    public func resetUserPassword(username: String,
                                  userId: String,
                                  seed: String,
                                  seedHash: String,
                                  newPassword: String, _ callback: @escaping UpvestCompletion<BasicResult>) {
        Upvest.submit(operation: ResetUserPasswordOperation(authManager: self.authManager, api: api, clientId: self.clientId, username: username, userId: userId, seed: seed, seedHash: seedHash, newPassword: newPassword, callback: callback))
    }

    /// Retrieve Users
    ///
    /// - Parameters:
    ///   - callback: UpvestCompletion (CursorResult<User>, Error?)
    public func getUsers(_ callback: @escaping UpvestCompletion<CursorResult<User>>) {
        Upvest.submit(operation: GetUsersOperation(authManager: self.authManager, api: api, clientId: self.clientId,
                                                   callback: callback))
    }

    /// Cursor for Users result
    ///
    /// - Parameter result: CursorResult<User>
    /// - Returns: APICursor<User>
    public func cursor(_ result: CursorResult<User>) -> APICursor<User> {
        return super.cursor(result)
    }

    /// Echo from Tenancy API using `GET`
    ///
    /// - Parameters:
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion<Echo> callback
    public func getEcho(echo: String, callback: @escaping UpvestCompletion<Echo>) {
        Upvest.submit(operation: GetApiKeySignedEchoOperation(authManager: self.authManager, api: api, clientId: self.clientId, echo: echo, callback: callback))
    }

    /// Echo from Tenancy API using `POST`
    ///
    /// - Parameters:
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion<Echo> callback
    public func postEcho(echo: String, callback: @escaping UpvestCompletion<Echo>) {
        Upvest.submit(operation: PostApiKeySignedEchoOperation(authManager: self.authManager, api: api, clientId: self.clientId, echo: echo, callback: callback))
    }

}
