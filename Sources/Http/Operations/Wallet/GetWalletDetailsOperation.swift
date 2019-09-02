//
//  GetWalletDetailsOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 30/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get Wallet Details Operation
internal class GetWalletDetailsOperation: BaseOperation<Wallet> {
    fileprivate let resource: () -> HTTPResource<Wallet>
    fileprivate var callback: UpvestCompletion<Wallet>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client ID
    ///   - walletId: Unique wallet ID.
    ///   - callback: UpvestCompletion (Wallet, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                walletId: String,
                callback: @escaping UpvestCompletion<Wallet>) {
        self.callback = callback
        resource = {
            APIDefinition.getWalletInfomation(walletId: walletId)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
