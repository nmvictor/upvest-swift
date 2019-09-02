//
//  WalletsAPI.swift
//  UpvestTests
//
//  Created by Moin' Victor on 30/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Wallets API
public class WalletsAPI: BaseAPI {

    ///////////////////////////////////////////// OPERATIONS /////////////////////////////////////////////

    /// Create Wallet
    ///
    /// - Parameters:
    ///   - assetId: The ID of the asset the wallet should hold.
    ///   - type: The type of wallet to create. Default is `encrypted`
    ///   - index: BIP44 index.
    ///   - password: The password is necessary to decrypt the Seed data to create the private key for the new wallet, and then to encrypt the new private key.
    ///   - callback: UpvestCompletion (Wallet, Error?)
    public func createWallet(assetId: String, type: Wallet.`Type` = .encrypted, index: Int, password: String, _ callback: @escaping UpvestCompletion<Wallet>) {
        Upvest.submit(operation: CreateWalletOperation(authManager: self.authManager, api: api, clientId: self.clientId, assetId: assetId, type: type, index: index, password: password, callback: callback))
    }

    /// Get Wallet Information
    ///
    /// - Parameters:
    ///   - id: Unique wallet ID.
    ///   - callback: UpvestCompletion (Wallet, Error?)
    public func getWallet(byId id: String, _ callback: @escaping UpvestCompletion<Wallet>) {
        Upvest.submit(operation: GetWalletDetailsOperation(authManager: self.authManager, api: api, clientId: self.clientId, walletId: id, callback: callback))
    }

    /// List Wallets
    ///
    /// - Parameters:
    ///   - callback: UpvestCompletion (CursorResult<Wallet>, Error?)
    public func list(_ callback: @escaping UpvestCompletion<CursorResult<Wallet>>) {
        Upvest.submit(operation: GetCursorResultOperation<Wallet>(authManager: self.authManager, api: api, clientId: self.clientId, url: "/wallets", callback: callback))
    }

    /// Create Transaction
    ///
    /// - Parameters:
    ///   - walletId: Unique wallet ID.
    ///   - assetId: The ID of the asset the wallet should hold.
    ///   - quantity: The amount to send.
    ///   - fee: The fee to be paid for sending the transaction.
    ///   - password: The password is necessary to decrypt the Seed data to create the private key for the new wallet, and then to encrypt the new private key.
    ///   - callback: UpvestCompletion (Transaction, Error?)
    public func createTransaction(walletId: String, assetId: String, quantity: String, fee: String, password: String, _ callback: @escaping UpvestCompletion<Transaction>) {
        Upvest.submit(operation: CreateTransactionOperation(authManager: self.authManager, api: api, clientId: self.clientId, walletId: walletId, assetId: assetId, quantity: quantity, fee: fee, password: password, callback: callback))
    }

    /// Get Transaction Information
    ///
    /// - Parameters:
    ///   - walletId: Unique wallet ID.
    ///   - tranxId: Unique Transaction ID.
    ///   - callback: UpvestCompletion (Transaction, Error?)
    public func getTransaction(forWallet walletId: String, tranxId: String, _ callback: @escaping UpvestCompletion<Transaction>) {
        Upvest.submit(operation: GetTransactionDetailsOperation(authManager: self.authManager, api: api, clientId: self.clientId, walletId: walletId, tranxId: tranxId, callback: callback))
    }

    /// List Transactions
    ///
    /// - Parameters:
    ///   - walletId: Unique wallet ID.
    ///   - callback: UpvestCompletion (CursorResult<Transaction>, Error?)
    public func listTransactions(forWallet walletId: String, _ callback: @escaping UpvestCompletion<CursorResult<Transaction>>) {
        Upvest.submit(operation: GetCursorResultOperation<Transaction>(authManager: self.authManager, api: api, clientId: self.clientId, url: "/wallets/\(walletId)/transactions", callback: callback))
    }

    /// Sign (the hash of) data with the private key corresponding to this wallet.
    ///
    /// - Parameters:
    ///   - walletId: The unique ID of the wallet to create a signature with.
    ///   - toSign: A string representation of the 32 byte long hash to be signed. The format is determined by the "input_format" parameter.
    ///   - inputFormat: The name of the string format for the hash to be signed.
    ///   - outputFormat: The name of the string format for the big numbers in the signature. (Some JSON implementations can not handle integers which need more than 64 bits to be represented.)
    ///   - password: The password is necessary to decrypt the Seed data to create the private key for the new wallet, and then to encrypt the new private key.
    ///   - callback: UpvestCompletion (SignedWithWalletResult, Error?)
    public func sign(_ toSign: String, withWallet walletId: String, inputFormat: Wallet.SignInputFormat, outputFormat: Wallet.SignOutputFormat, password: String, _ callback: @escaping UpvestCompletion<SignedWithWalletResult>) {
        Upvest.submit(operation: SignWithWalletOperation(authManager: self.authManager, api: api, clientId: self.clientId, walletId: walletId, toSign: toSign, inputFormat: inputFormat, outputFormat: outputFormat, password: password, callback: callback))
    }

    /// Cursor for Wallets result
    ///
    /// - Parameter result: CursorResult<Wallet>
    /// - Returns: APICursor<Wallet>
    public func cursor(_ result: CursorResult<Wallet>) -> APICursor<Wallet> {
        return super.cursor(result)
    }

    /// Cursor for Transactions result
    ///
    /// - Parameter result: CursorResult<Transaction>
    /// - Returns: APICursor<Transaction>
    public func cursor(_ result: CursorResult<Transaction>) -> APICursor<Transaction> {
        return super.cursor(result)
    }
}
