//
//  AssetsAPI.swift
//  Upvest
//
//  Created by Moin' Victor on 28/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Assets API
public class AssetsAPI: BaseAPI {

    ///////////////////////////////////////////// OPERATIONS /////////////////////////////////////////////

    /// Get Asset Information
    ///
    /// - Parameters:
    ///   - is: Unique asset ID.
    ///   - callback: UpvestCompletion (User, Error?)
    public func getAssetInfo(byAssetId id: String, _ callback: @escaping UpvestCompletion<Asset>) {
        Upvest.submit(operation: GetAssetDetailsOperation(authManager: self.authManager, api: api, clientId: self.clientId, assetId: id, callback: callback))
    }

    /// List Assets
    ///
    /// - Parameters:
    ///   - callback: UpvestCompletion (CursorResult<User>, Error?)
    public func list(_ callback: @escaping UpvestCompletion<CursorResult<Asset>>) {
        Upvest.submit(operation: GetCursorResultOperation<Asset>(authManager: self.authManager, api: api, clientId: self.clientId, url: "/assets", callback: callback))
    }

}
