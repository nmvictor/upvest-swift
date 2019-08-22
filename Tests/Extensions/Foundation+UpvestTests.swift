//
//  Foundation+UpvestTests.swift
//  Upvest
//
//  Created by Moin' Victor on 22/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

public extension Data {

    /// Converts Data to dictionary
    ///
    /// - Returns: Dictionary or nil if conversion fails
    func asDict() -> [String: Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) {
            return json as? [String: Any]
        }
        return nil
    }
}

public extension Data {
    /// Converts Data to String
    ///
    /// - Returns: String representation of the Data
    func toString() -> String {
        return String(data: self, encoding: .utf8)!
    }
}

/// Operator to compare dictionary values
///
/// - Parameters:
///   - lhs: Left hand side dictionary
///   - rhs: Right hand side dictionary
/// - Returns: True if the dictionaries match by key and corresponding values
public func == (lhs: [String: Any], rhs: [String: Any] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
