//
//  CreateWalletOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 01/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Create Wallet Operation
internal class CreateWalletOperation: BaseOperation<Wallet> {
    fileprivate let resource: () -> HTTPResource<Wallet>
    fileprivate var callback: UpvestCompletion<Wallet>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - assetId: The ID of the asset the wallet should hold.
    ///   - type: The type of wallet to create
    ///   - index: BIP44 index.
    ///   - password: The password is necessary to decrypt the Seed data to create the private key for the new wallet, and then to encrypt the new private key.
    ///   - callback: UpvestCompletion (Wallet, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                assetId: String,
                type: Wallet.`Type`,
                index: Int,
                password: String,
                callback: @escaping UpvestCompletion<Wallet>) {
        self.callback = callback
        resource = {
            APIDefinition.createWallet(assetId: assetId, type: type, index: index, password: password)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
