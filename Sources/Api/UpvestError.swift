//
//  UpvestError.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// A custom error enum that indicates why a Upvest operation has failed.
public enum UpvestError: Error {
    /// An error indicating that the request could not be performed because
    /// the auth are not available.
    case noCredentials

    /// An error indicating that the request could not be performed because
    /// authorization has failed.
    case authFailed(String)

    /// A catch-all error, for issues that don't fall into other cases.
    case other(String)

    /// A friendly human-readable description of the error that occurred.
    public var description: String {
        switch self {
        case .noCredentials:
            return "There are no available credentials"
        case .authFailed(let details):
            return "Authentication failed: \(details)"
        case .other(let details):
            return "Error: \(details)"
        }
    }
}
