//
//  Wallet.swift
//  Upvest
//
//  Created by Moin' Victor on 29/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Wallet
public class Wallet: Codable {

    /// The name of the string format for the hash to be signed.
    ///
    /// - base64: base64 format
    /// - hex: hex format
    public enum SignInputFormat: String, Codable {
        case base64
        case hex
    }

    /// The name of the string format for the big numbers in the signature.
    ///
    /// - base64BigEndian: base64 bigendian format
    /// - base64LittleEndian: base64 littleendian format
    /// - hex: hex format
    /// - decimal: decimal format
    /// - int: int format
    public enum SignOutputFormat: String, Codable {
        case base64BigEndian = "base64_bigendian"
        case base64LittleEndian = "base64_littleendian"
        case hex
        case decimal
        case int
    }

    /// Wallet Type
    ///
    /// - encrypted: Encrypted Wallet
    public enum `Type`: String, Codable {
        case encrypted
    }

    /// Wallet Balance
    public class Balance: Codable {
        /// The name of the underlying asset.
        /// See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
        public internal(set) var name: String!
        /// The symbol of the underlying asset.
        public internal(set) var symbol: String!
        /// The exponent of the underlying asset.
        public internal(set) var exponent: Int!
        /// Amount of asset held.
        public internal(set) var amount: String!
        /// Asset Id
        public internal(set) var assetId: String!

        private enum CodingKeys: String, CodingKey {
            case name
            case symbol
            case exponent
            case assetId = "asset_id"
            case amount
        }

        /// Init from JSONDecoder
        ///
        /// - Parameter decoder: The JSONDecoder
        /// - Throws: dataCorruptedError if any required fields are missing
        public required init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
            name = try? container.decode(String.self, forKey: .name)
            symbol = try? container.decode(String.self, forKey: .symbol)
            exponent = try? container.decode(Int.self, forKey: .exponent)
            amount = try? container.decode(String.self, forKey: .amount)
            assetId = try? container.decode(String.self, forKey: .assetId)
            try validateFields(container)
        }

        private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
            if name == nil {
                throw DecodingError.dataCorruptedError(forKey: .name,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.name.rawValue)` or is not a String value")
            }
            if symbol == nil {
                throw DecodingError.dataCorruptedError(forKey: .symbol,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.symbol.rawValue)` or is not a String value")
            }
            if exponent == nil {
                throw DecodingError.dataCorruptedError(forKey: .exponent,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.exponent.rawValue)` or is not a Int value")
            }
            if amount == nil {
                throw DecodingError.dataCorruptedError(forKey: .amount,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.amount.rawValue)` or is not a String value")
            }
        }
    }

    /// Unique wallet ID.
    public internal(set) var id: String!
    /// Wallet Status. Usually "ACTIVE". Can be "PENDING" during key creation and (re-)encryption.
    public internal(set) var status: String!
    /// Public address.
    public internal(set) var address: String!
    /// BIP44 index.
    public internal(set) var index: Int!
    /// Technical Details of the type of protocol this wallet represents.
    /// See https://doc.upvest.co/docs/protocols
    public internal(set) var `protocol`: String!
    /// Balance as a string representation of an integer, in base 10, for example 1234.
    /// See also https://doc.upvest.co/v1.0/reference/kms#section-wallet-balances
    public internal(set) var balances = [Balance]()

    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case address
        case index
        case `protocol`
        case balances
    }

    /// Init from JSONDecoder
    ///
    /// - Parameter decoder: The JSONDecoder
    /// - Throws: dataCorruptedError if any required fields are missing
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        status = try? container.decode(String.self, forKey: .status)
        address = try? container.decode(String.self, forKey: .address)
        index = try? container.decode(Int.self, forKey: .index)
        `protocol` = try? container.decode(String.self, forKey: .`protocol`)
        balances = try container.decode([Balance].self, forKey: .balances)
        try validateFields(container)
    }

    private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
        if id == nil {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.id.rawValue)` or is not a String value")
        }
        if status == nil {
            throw DecodingError.dataCorruptedError(forKey: .status,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.status.rawValue)` or is not a String value")
        }
        if address == nil {
            throw DecodingError.dataCorruptedError(forKey: .address,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.address.rawValue)` or is not a String value")
        }
        if index == nil {
            throw DecodingError.dataCorruptedError(forKey: .index,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.index.rawValue)` or is not a Int value")
        }
        if `protocol` == nil {
            throw DecodingError.dataCorruptedError(forKey: .`protocol`,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.`protocol`.rawValue)` or is not a String value")
        }
    }
}
