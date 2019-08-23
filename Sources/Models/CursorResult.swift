//
//  CursorResult.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

public class CursorResult<T: Codable>: Codable {
    internal var previous: String?
    internal var next: String?
    public internal(set) var results: [T] = [T]()

    private enum CodingKeys: String, CodingKey {
        case previous
        case next
        case results
    }

    /// Init from JSONDecoder
    ///
    /// - Parameter decoder: The JSONDecoder
    /// - Throws: dataCorruptedError if any required fields are missing
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        previous = try? container.decode(String.self, forKey: .previous)
        next = try? container.decode(String.self, forKey: .next)
        results = try container.decode([T].self, forKey: .results)
    }
}
