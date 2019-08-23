//
//  ApiKeySignedEchoOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get API Key Signed Echo Operation
internal class GetApiKeySignedEchoOperation: BaseOperation<Echo> {
    fileprivate let resource: () -> HTTPResource<Echo>
    fileprivate var callback: UpvestCompletion<Echo>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Auth.
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion (Echo, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                echo: String,
                callback: @escaping UpvestCompletion<Echo>) {
        self.callback = callback
        resource = {
            APIDefinition.getEchoSigned(echo: echo)
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

/// Post API Key Signed Echo Operation
internal class PostApiKeySignedEchoOperation: BaseOperation<Echo> {
    fileprivate let resource: () -> HTTPResource<Echo>
    fileprivate var callback: UpvestCompletion<Echo>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Auth.
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - echo: The string to echo
    ///   - callback: UpvestCompletion (Echo, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                echo: String,
                callback: @escaping UpvestCompletion<Echo>) {
        self.callback = callback
        resource = {
            APIDefinition.postEchoSigned(echo: echo)
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
