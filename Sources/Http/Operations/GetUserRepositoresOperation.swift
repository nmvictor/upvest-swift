//
//  GetUserRepositoresOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get User Repositories Operation
internal class GetUserRepositoresOperation: BaseOperation<[Repository]> {
    fileprivate let resource: () -> HTTPResource<[Repository]>
    fileprivate var callback: UpvestCompletion<[Repository]>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - username: The optional username, if not provided, we get repos for current user authenticated by token
    ///   - callback: UpvestCompletion ([Repository], Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                username: String? = nil,
                callback: @escaping UpvestCompletion<[Repository]>) {
        self.callback = callback
        resource = {
            APIDefinition.getUserRepositories(username: username)
        }
        super.init(authManager: authManager, api: api, clientId: "")
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
