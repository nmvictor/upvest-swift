//
//  SignedWithWalletResult.swift
//  Upvest
//
//  Created by Moin' Victor on 02/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

// swiftlint:disable nesting
import Foundation

/// Signed With Wallet Result
public class SignedWithWalletResult: Codable {

    /// The public key of the wallet.
    public struct PublicKey: Codable {

        /// The x coordinate of the public key of the wallet.
        /// Represented in the format given in the "big_number_format" field.
        public internal(set) var x: String?
        /// The y coordinate of the public key of the wallet.
        /// Represented in the format given in the "big_number_format" field.
        public internal(set) var y: String?

        private enum CodingKeys: String, CodingKey {
            case x
            case y
        }
    }

    /// Has the same value as the "output_format" parameter.
    /// The name of the string format for the big numbers in the signature.
    /// (Some JSON implementations can not handle integers which need more than 64 bits to be represented.)
    public internal(set) var bigNumberFormat: String!
    /// The encryption algorithm used. (Currently only ECDSA)
    public internal(set) var algorithm: String!
    /// The name of the elliptic curve used.
    public internal(set) var curve: String!
    /// The public key of the wallet.
    public internal(set) var publicKey: PublicKey!
    /// The "r" signature component. Represented in the format given in the "big_number_format" field.
    public internal(set) var r: String!
    /// The "s" signature component. Represented in the format given in the "big_number_format" field.
    public internal(set) var s: String!
    /// The "recover" signature component, sometimes also called "v".
    /// Since this is a small integer with less than 64 bits, this is an actual JSON integer,
    /// and NOT represented in the big integer format.
    public internal(set) var recover: String!

    private enum CodingKeys: String, CodingKey {
        case bigNumberFormat = "big_number_format"
        case algorithm
        case curve
        case publicKey = "public_key"
        case r
        case s
        case recover
    }

    /// Init from JSONDecoder
    ///
    /// - Parameter decoder: The JSONDecoder
    /// - Throws: dataCorruptedError if any required fields are missing
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        bigNumberFormat = try? container.decode(String.self, forKey: .bigNumberFormat)
        algorithm = try? container.decode(String.self, forKey: .algorithm)
        curve = try? container.decode(String.self, forKey: .curve)
        publicKey = try? container.decode(PublicKey.self, forKey: .publicKey)
        r = try? container.decode(String.self, forKey: .r)
        s = try? container.decode(String.self, forKey: .s)
        recover = try? container.decode(String.self, forKey: .recover)
        try validateFields(container)
    }

    private func validateFields(_ container: KeyedDecodingContainer<CodingKeys>) throws {
        if bigNumberFormat == nil {
            throw DecodingError.dataCorruptedError(forKey: .bigNumberFormat,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.bigNumberFormat.rawValue)` or is not a String value")
        }
        if algorithm == nil {
            throw DecodingError.dataCorruptedError(forKey: .algorithm,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.algorithm.rawValue)` or is not a String value")
        }
        if curve == nil {
            throw DecodingError.dataCorruptedError(forKey: .curve,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.curve.rawValue)` or is not a String value")
        }
        if publicKey == nil {
            throw DecodingError.dataCorruptedError(forKey: .publicKey,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.publicKey.rawValue)` or is not a PublicKey value")
        }
        if r == nil {
            throw DecodingError.dataCorruptedError(forKey: .r,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.r.rawValue)` or is not a String value")
        }
        if s == nil {
            throw DecodingError.dataCorruptedError(forKey: .s,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.s.rawValue)` or is not a String value")
        }
        if recover == nil {
            throw DecodingError.dataCorruptedError(forKey: .recover,
                                                   in: container,
                                                   debugDescription: "JSON must contain the field `\(CodingKeys.recover.rawValue)` or is not a String value")
        }
    }
}
