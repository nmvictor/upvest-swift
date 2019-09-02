//
//  CreateTransactionOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 02/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Create Transaction Operation
internal class CreateTransactionOperation: BaseOperation<Transaction> {
    fileprivate let resource: () -> HTTPResource<Transaction>
    fileprivate var callback: UpvestCompletion<Transaction>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - walletId: Unique wallet ID.
    ///   - assetId: The ID of the asset the wallet should hold.
    ///   - quantity: The amount to send.
    ///   - fee: The fee to be paid for sending the transaction.
    ///   - password: The password is necessary to decrypt the Seed data to create the private key for the new wallet, and then to encrypt the new private key.
    ///   - callback: UpvestCompletion (Transaction, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                walletId: String,
                assetId: String,
                quantity: String,
                fee: String,
                password: String,
                callback: @escaping UpvestCompletion<Transaction>) {
        self.callback = callback
        resource = {
            APIDefinition.createTransaction(walletId: walletId, assetId: assetId, quantity: quantity, fee: fee, password: password)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
