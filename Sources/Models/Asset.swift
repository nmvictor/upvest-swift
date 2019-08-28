//
//  Asset.swift
//  Upvest
//
//  Created by Moin' Victor on 28/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Asset
public class Asset: Codable {
    /// Asset Metadata
    public struct Metadata: Codable {
        /// For Ethereum assets, the EIP-155 Chain ID.
        /// See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
        public internal(set) var chainId: Int?
        /// For Ethereum ERC20 assets, the Ethereum address of the underlying smart contract.
        public internal(set) var contract: String?
        /// For Bitcoin and Arweave assets, the block hash of the genesis block.
        public internal(set) var genesis: String?

        private enum CodingKeys: String, CodingKey {
            case chainId = "chain_id"
            case contract
            case genesis
        }
    }

    /// Unique asset ID
    public internal(set) var id: String!
    /// The name of the asset.
    public internal(set) var name: String!
    /// The "ticker symbol" of the asset.
    public internal(set) var symbol: String!
    /// The exponent is the number of decimal places between the smallest denomination and the default denomination of the asset.
    public internal(set) var exponent: Int!
    /// Technical Details of the type of protocol this asset represents.
    /// See https://doc.upvest.co/docs/protocols
    public internal(set) var `protocol`: String!
    /// Some technical details to uniquely identify the asset.
    public internal(set) var metadata: Metadata?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case exponent
        case `protocol`
        case metadata
    }

    /// Init from JSONDecoder
    ///
    /// - Parameter decoder: The JSONDecoder
    /// - Throws: dataCorruptedError if any required fields are missing
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        symbol = try? container.decode(String.self, forKey: .symbol)
        exponent = try? container.decode(Int.self, forKey: .exponent)
        `protocol` = try? container.decode(String.self, forKey: .`protocol`)
        metadata = try? container.decode(Metadata.self, forKey: .metadata)
        try validateFields(container)
    }

    private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
        if id == nil {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.id.rawValue)` or is not a String value")
        }
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
        if `protocol` == nil {
            throw DecodingError.dataCorruptedError(forKey: .`protocol`,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.`protocol`.rawValue)` or is not a String value")
        }
    }
}
