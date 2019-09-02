//
//  Transaction.swift
//  Upvest
//
//  Created by Moin' Victor on 01/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

// swiftlint:disable type_body_length function_body_length cyclomatic_complexity

import Foundation

/// Transaction
public class Transaction: Codable {
    /// Transaction Status.
    ///
    /// - pending: The transaction has been sent to the blockchain network, but has not been included in a block yet. - "CONFIRMING": The transaction has been included in a block.
    /// - confirming: The transaction has been included in a block.
    /// - confirmed: The transaction has been confirmed by a sufficient number of blocks that have been mined after the block this transaction was included in.
    /// - failed: The transaction timed out while waiting to be included in a block.
    /// - rejected: The transaction could not be included in a block. Reasons include but are not limited to: Insufficient funds for amount + fee; error during smart contract execution.
    public enum Status: String, Codable {
        case pending = "PENDING"
        case confirming = "CONFIRMING"
        case confirmed = "CONFIRMED"
        case failed = "FAILED"
        case rejected = "REJECTED"
    }

    /// Unique transaction ID.
    public internal(set) var id: String!
    /// The transaction hash.
    public internal(set) var txHash: String!
    /// Unique wallet ID.
    public internal(set) var walletId: String!
    /// The ID of the asset sent or received.
    public internal(set) var assetId: String!
    /// The name of the asset sent or received.
    public internal(set) var assetName: String!
    /// The address of the transaction's sender.
    public internal(set) var sender: String!
    /// The address of the transaction's recipient.
    public internal(set) var recipient: String!
    /// The exponent is the number of decimal places between the smallest denomination and the default denomination of the asset.
    /// Example: Bitcoin's smallest denomination is one "Satoshi", which is 0.00000001 Bitcoin.
    public internal(set) var exponent: Int!
    /// The value of the transaction.
    public internal(set) var quantity: String!
    /// The fee paid for the transaction.
    public internal(set) var fee: String!
    /// Transaction Status.
    public internal(set) var status: Status!

    private enum CodingKeys: String, CodingKey {
        case id
        case txHash = "txhash"
        case walletId = "wallet_id"
        case assetId = "asset_id"
        case assetName = "asset_name"
        case sender
        case recipient
        case exponent
        case quantity
        case fee
        case status
    }

    /// Init from JSONDecoder
    ///
    /// - Parameter decoder: The JSONDecoder
    /// - Throws: dataCorruptedError if any required fields are missing
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        txHash = try? container.decode(String.self, forKey: .txHash)
        walletId = try? container.decode(String.self, forKey: .walletId)
        assetId = try? container.decode(String.self, forKey: .assetId)
        assetName = try? container.decode(String.self, forKey: .assetName)
        sender = try? container.decode(String.self, forKey: .sender)
        recipient = try? container.decode(String.self, forKey: .recipient)
        exponent = try? container.decode(Int.self, forKey: .exponent)
        quantity = try container.decode(String.self, forKey: .quantity)
        fee = try container.decode(String.self, forKey: .fee)
        status = try? container.decode(Status.self, forKey: .status)
        try validateFields(container)
    }

    private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
        if id == nil {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.id.rawValue)` or is not a String value")
        }
        if txHash == nil {
            throw DecodingError.dataCorruptedError(forKey: .txHash,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.txHash.rawValue)` or is not a String value")
        }
        if walletId == nil {
            throw DecodingError.dataCorruptedError(forKey: .walletId,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.walletId.rawValue)` or is not a String value")
        }
        if assetId == nil {
            throw DecodingError.dataCorruptedError(forKey: .assetId,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.assetId.rawValue)` or is not a String value")
        }
        if assetName == nil {
            throw DecodingError.dataCorruptedError(forKey: .assetName,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.assetName.rawValue)` or is not a String value")
        }
        if sender == nil {
            throw DecodingError.dataCorruptedError(forKey: .sender,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.sender.rawValue)` or is not a String value")
        }
        if recipient == nil {
            throw DecodingError.dataCorruptedError(forKey: .recipient,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.recipient.rawValue)` or is not a String value")
        }
        if status == nil {
            throw DecodingError.dataCorruptedError(forKey: .status,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.status.rawValue)` or is not a String value")
        }
        if quantity == nil {
            throw DecodingError.dataCorruptedError(forKey: .quantity,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.quantity.rawValue)` or is not a String value")
        }
        if fee == nil {
            throw DecodingError.dataCorruptedError(forKey: .fee,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.fee.rawValue)` or is not a String value")
        }
        if exponent == nil {
            throw DecodingError.dataCorruptedError(forKey: .exponent,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.exponent.rawValue)` or is not a Int value")
        }
        if status == nil {
            throw DecodingError.dataCorruptedError(forKey: .status,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.status.rawValue)` or is not a Status value")
        }
    }
}
