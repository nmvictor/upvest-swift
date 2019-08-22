//
//  ResourceError.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
/// A custom error enum that indicates why requesting a resource has failed.
enum ResourceError: Error {
  /// Error 401
  case unauthorized
  /// An error indicating the request times out or there is no network.
  case unreachable
  /// An error indicating that a non-success HTTP status code (i.e. non-200)
  /// was returned.
  case invalidResponse(statusCode: Int, responseText: String)

  /// An error indicating that no data was returned in the HTTP response.
  case noData

  /// An error indicating that data was returned, but could not be parsed into
  /// the desired Type (using the `HTTPResource`'s `parse` property).
  case couldNotParse(data: Data)

  /// A catch-all error, for errors that fall outside the above specifically-
  /// delineated errors.
  case other(Error?)
}
