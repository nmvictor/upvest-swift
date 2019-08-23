//
//  GetCursorResultOperation.swift
//  UpvestTests
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get CursorResult<T> Operation
internal class GetCursorResultOperation<T: Codable>: BaseOperation<CursorResult<T>> {
    fileprivate let resource: () -> HTTPResource<CursorResult<T>>
    fileprivate var callback: UpvestCompletion<CursorResult<T>>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - url: The cursor url
    ///   - callback: UpvestCompletion (CursorResult<T>, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                url: String,
                callback: @escaping UpvestCompletion<CursorResult<T>>) {
        self.callback = callback
        resource = {
            APIDefinition.getCursorResult(url: url)
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
