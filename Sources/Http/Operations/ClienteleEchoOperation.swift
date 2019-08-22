//
//  ClienteleEchoOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 22/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get Clientele Echo Operation
internal class GetClienteleEchoOperation: BaseOperation<Echo> {
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
            APIDefinition.getEchoOAuth2(echo: echo)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}


/// Post Clientele Echo Operation
internal class PostClienteleEchoOperation: BaseOperation<Echo> {
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
            APIDefinition.postEchoOAuth2(echo: echo)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
