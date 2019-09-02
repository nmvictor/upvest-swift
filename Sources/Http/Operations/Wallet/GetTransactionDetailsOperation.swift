//
//  GetTransactionDetailsOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 02/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Get Transaction Details Operation
internal class GetTransactionDetailsOperation: BaseOperation<Transaction> {
    fileprivate let resource: () -> HTTPResource<Transaction>
    fileprivate var callback: UpvestCompletion<Transaction>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client ID
    ///   - walletId: Unique wallet ID.
    ///   - tranxId: Unique Transaction ID.
    ///   - callback: UpvestCompletion (Transaction, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                walletId: String,
                tranxId: String,
                callback: @escaping UpvestCompletion<Transaction>) {
        self.callback = callback
        resource = {
            APIDefinition.getTransactionInfomation(walletId: walletId, tranxId: tranxId)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
