//
//  Repository.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// Available Shift
public class Repository: Codable {
    public internal(set) var id: Int!
    public internal(set) var fullName: String!
    public internal(set) var url: String!
    public internal(set) var isPrivate: Bool! = false
    public internal(set) var owner: Owner!

    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case url
        case isPrivate = "private"
        case owner
    }

    /// Init from JSONDecoder
    ///
    /// - Parameter decoder: The JSONDecoder
    /// - Throws: dataCorruptedError if any required fields are missing
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        fullName = try? container.decode(String.self, forKey: .fullName)
        url = try? container.decode(String.self, forKey: .url)
        isPrivate = try? container.decode(Bool.self, forKey: .isPrivate)
        owner = try? container.decode(Owner.self, forKey: .owner)
        try validateFields(container)
    }

    private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
        if id == nil {
            throw DecodingError.dataCorruptedError(forKey: .id,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.id.rawValue)` or is not a Int value")
        }

        if fullName == nil {
            throw DecodingError.dataCorruptedError(forKey: .fullName,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.fullName.rawValue)` or is not a String value")
        }

        if url == nil {
            throw DecodingError.dataCorruptedError(forKey: .url,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.url.rawValue)` or is not a String value")
        }

        if owner == nil {
            throw DecodingError.dataCorruptedError(forKey: .owner,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.owner.rawValue)` or is not a Owner object value")
        }
    }

    public class Owner: Codable {
        public internal(set) var id: Int!
        public internal(set) var login: String!
        public internal(set) var url: String!
        public internal(set) var type: String!
        public internal(set) var avatarUrl: String!

        private enum CodingKeys: String, CodingKey {
            case id
            case login
            case url
            case type
            case avatarUrl = "avatar_url"
        }

        /// Init from JSONDecoder
        ///
        /// - Parameter decoder: The JSONDecoder
        /// - Throws: dataCorruptedError if any required fields are missing
        public required init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
            id = try? container.decode(Int.self, forKey: .id)
            login = try? container.decode(String.self, forKey: .login)
            url = try? container.decode(String.self, forKey: .url)
            type = try? container.decode(String.self, forKey: .type)
            avatarUrl = try? container.decode(String.self, forKey: .avatarUrl)
            try validateFields(container)
        }

        private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
            if id == nil {
                throw DecodingError.dataCorruptedError(forKey: .id,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.id.rawValue)` or is not a Int value")
            }

            if login == nil {
                throw DecodingError.dataCorruptedError(forKey: .login,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.login.rawValue)` or is not a String value")
            }

            if url == nil {
                throw DecodingError.dataCorruptedError(forKey: .url,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.url.rawValue)` or is not a String value")
            }

            if type == nil {
                throw DecodingError.dataCorruptedError(forKey: .type,
                                                       in: container,
                                                       debugDescription: "JSON must contain the field `\(CodingKeys.type.rawValue)` or is not a String value")
            }
        }
    }
}
