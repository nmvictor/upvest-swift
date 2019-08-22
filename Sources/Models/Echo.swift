//
//  Echo.swift
//  Upvest
//
//  Created by Moin' Victor on 22/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// A value object to represent echo response from Upvest API.
public struct Echo {
    /// Echo string
    public let echo: String!
}

extension Echo: Codable {
}
