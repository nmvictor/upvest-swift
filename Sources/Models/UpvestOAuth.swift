//
//  UpvestOAuth.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// A value object to represent the auth needed to interact with the
/// Upvest API.
public struct UpvestOAuth {
    /// A unique, transient token for the auth.
    public let accessToken: String!
    /// Token Type
    public let tokenType: String!
    /// The scope string
    public let scope: String?
    /// Expires In
    public let expiresIn: Int?
    /// Refresh Token
    public let refreshToken: String!
}

// MARK: - Codable
extension UpvestOAuth: Codable {

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}

// MARK: - Equality
extension UpvestOAuth: Equatable {
    public static func == (lhs: UpvestOAuth, rhs: UpvestOAuth) -> Bool {
        return lhs.accessToken == rhs.accessToken
    }
}

// MARK: - LocalObjectType to help store this object
extension UpvestOAuth: LocalObjectType {
    public var attributes: [String: Any] {
        return ["access_token": accessToken as Any,
                "refresh_token": refreshToken as Any,
                "scope": scope as Any,
                "expires_in": expiresIn as Any,
                "token_type": tokenType as Any]
    }

    public init?(attributes: [String: Any]) {
        guard let token = attributes["access_token"] as? String else { return nil }
        accessToken = token
        refreshToken = attributes["refresh_token"] as? String
        tokenType = attributes["token_type"] as? String
        scope = attributes["scope"] as? String
        expiresIn = attributes["expires_in"] as? Int
    }
}
