//
//  User.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// User
public class User: Codable {
    /// Username
    public internal(set) var username: String!
    /// Recovery kit represented as SVG
    public internal(set) var recoverykit: String?
    /// IDs of the wallets created for this new user.
    public internal(set) var walletIds: [String] = [String]()

    private enum CodingKeys: String, CodingKey {
        case username
        case recoverykit = "recoverykit"
        case walletIds = "wallet_ids"
    }

    /// Init from JSONDecoder
    ///
    /// - Parameter decoder: The JSONDecoder
    /// - Throws: dataCorruptedError if any required fields are missing
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        username = try? container.decode(String.self, forKey: .username)
        recoverykit = try? container.decode(String.self, forKey: .recoverykit)
        if let walletIds = try? container.decode([String].self, forKey: .walletIds) {
            self.walletIds = walletIds
        }
        try validateFields(container)
    }

    private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
        if username == nil {
            throw DecodingError.dataCorruptedError(forKey: .username,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.username.rawValue)` or is not a String value")
        }
    }
}
