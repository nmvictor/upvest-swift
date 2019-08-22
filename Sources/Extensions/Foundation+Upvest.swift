//
//  Foundation+Upvest.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

extension Dictionary {
    /// Merges a dictionary into this one.
    ///
    /// - parameters:
    ///   - dictionary: the Dictionary to merge in
    func merged(with dictionary: [Key: Value]) -> [Key: Value] {
        var copy = self
        dictionary.forEach { copy.updateValue($1, forKey: $0) }
        return copy
    }
    
}

public extension Data {
    /// Converts Data to String
    ///
    /// - Returns: String representation of the Data
    func toString() -> String {
        return String(data: self, encoding: .utf8)!
    }

    func toJSONDictionary() -> JSONDictionary? {
        // Treat an existing but blank data as an empty JSON object
        guard self.count > 0 else { return [:] }

        // swiftlint:disable:next force_cast
        return try? JSONSerialization.jsonObject(with: self) as? JSONDictionary
    }

    internal func toJSONArray() -> JSONArray? {
        // Treat an existing but blank data as an empty JSON object
        guard self.count > 0 else { return [] }

        guard let arrayJson = try? JSONSerialization.jsonObject(with: self) as? JSONArray
            else {
                return nil
        }

        return arrayJson
    }
}

// MARK: - Dictionary as Data
public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {

    /// Get Data representation of this Dict
    var asData: Data? {
        guard self.count > 0 else { return nil }
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        if let dict = (self as AnyObject) as? Dictionary<String, AnyObject> {
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                return data
            } catch {
                print("Dictionary.asData Error: \(error)")
            }
        }
        return nil
    }
}

public extension JSONArray {

    /// Get Data representation of this JSONArray
    var asData: Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
