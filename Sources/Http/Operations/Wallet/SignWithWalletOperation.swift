//
//  SignWithWalletOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 02/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Sign With Wallet Operation
internal class SignWithWalletOperation: BaseOperation<SignedWithWalletResult> {
    fileprivate let resource: () -> HTTPResource<SignedWithWalletResult>
    fileprivate var callback: UpvestCompletion<SignedWithWalletResult>

    /// Initialize this object
    ///
    /// - parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client id
    ///   - walletId: The unique ID of the wallet to create a signature with.
    ///   - toSign: A string representation of the 32 byte long hash to be signed. The format is determined by the "input_format" parameter.
    ///   - inputFormat: The name of the string format for the hash to be signed.
    ///   - outputFormat: The name of the string format for the big numbers in the signature. (Some JSON implementations can not handle integers which need more than 64 bits to be represented.)
    ///   - password: The password is necessary to decrypt the Seed data to create the private key for the new wallet, and then to encrypt the new private key.
    ///   - callback: UpvestCompletion (Wallet, Error?)
    public init(authManager: AuthManager,
                api: UpvestAPIType,
                clientId: String,
                walletId: String,
                toSign: String,
                inputFormat: Wallet.SignInputFormat,
                outputFormat: Wallet.SignOutputFormat,
                password: String,
                callback: @escaping UpvestCompletion<SignedWithWalletResult>) {
        self.callback = callback
        resource = {
            APIDefinition.signWithWallet(walletId: walletId, toSign: toSign, inputFormat: inputFormat, outputFormat: outputFormat, password: password)
        }
        super.init(authManager: authManager, api: api, clientId: clientId)
    }

    /// Execute the operation
    override func start() {
        super.start()
        super.execute(resource: resource, completion: callback)
    }
}
