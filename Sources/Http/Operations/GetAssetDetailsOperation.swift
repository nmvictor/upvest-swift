//
//  GetAssetDetailsOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 28/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get Asset Details Operation
internal class GetAssetDetailsOperation: BaseOperation<Asset> {
    fileprivate let resource: () -> HTTPResource<Asset>
    fileprivate var callback: UpvestCompletion<Asset>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client ID
    ///   - assetId: Unique asset ID.
    ///   - callback: UpvestCompletion (Asset, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                assetId: String,
                callback: @escaping UpvestCompletion<Asset>) {
        self.callback = callback
        resource = {
            APIDefinition.getAssetInfomation(assetId: assetId)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
