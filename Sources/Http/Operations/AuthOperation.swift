//
//  AuthOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2018 Upvest. All rights reserved.
//
import Foundation

internal class AuthOperation: BaseOperation<UpvestOAuth> {
    fileprivate let resource: () -> HTTPResource<UpvestOAuth>
    fileprivate var callback: UpvestCompletion<UpvestOAuth>?

    /// Completion handler responsible for notifying sdk users
    private lazy var completionHandler: UpvestCompletion<UpvestOAuth> = {[weak self] (result) in
        switch result {
        case .success(let credential) :
            self?.authManager.currentAuth = credential
            self?.callback?(.success(credential))
        case .failure(let error) :
            self?.callback?(.failure(error))
        }
    }

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Auth.
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - clientSecret: Client secret
    ///   - scope: Scope
    ///   - username: Username
    ///   - password: Password
    ///   - callback: UpvestCompletion<UpvestOAuth>.
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                clientSecret: String,
                scope: String,
                username: String,
                password: String,
                callback: UpvestCompletion<UpvestOAuth>?) {
        self.callback = callback
        resource = {
            return APIDefinition.authenticate(clientId: clientId, clientSecret: clientSecret, scope: scope, username: username, password: password)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Override BaseOperation.validateOAuth: For this request we don't want to check
    /// if the oauth exists.
    override func validateOAuth() -> UpvestError? {
        return nil
    }

    // Execute the operation
    override func start() {
        super.start()
        if let credentials = self.authManager.currentAuth {
            completionHandler(Result<UpvestOAuth, UpvestError>.success(credentials))
            finish()
            return
        }
        super.execute(resource: resource, completion: completionHandler)
    }
}
