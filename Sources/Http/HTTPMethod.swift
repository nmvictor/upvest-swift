//
//  HTTPMethod.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

/// A simple enum to provide type safety around HTTP methods.
enum HTTPMethod: String {
  /// A HEAD method for an HTTP Request.
  case HEAD

  /// A GET method for an HTTP Request.
  case GET

  /// A POST method for an HTTP Request.
  case POST

  /// A PUT method for an HTTP Request.
  case PUT

  /// A DELETE method for an HTTP Request.
  case DELETE

  /// A PATCH method for an HTTP Request.
  case PATCH
}
