//
//  UpvestAPIType.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// A Type for a JSON dictionary (object)
public typealias JSONDictionary = [String: AnyObject]

/// A Type for a JSON array
typealias JSONArray = [JSONDictionary]

/// A closure used as a completion handler for API requests.
typealias APICompletion<A> = (Result<A, ResourceError>) -> Void

/// A protocol that indicates the required interface for being considered an
/// `UpvestAPI`
protocol UpvestAPIType {
  func request<A>(resource: HTTPResource<A>, completion: APICompletion<A>?)
  func request<A>(authToken: String?, resource: HTTPResource<A>, completion: APICompletion<A>?)
}

/// An API client for requesting Resources from the Upvest API. It wraps an
/// `HTTPResourceClientType` to layer in Upvest-specific API functionality, e.g.
/// handling of authentcation tokens.
class UpvestAPI: UpvestAPIType {
  /// The HTTP client to use for making network requests.
  private let client: HTTPResourceClientType

  /// Initialize this object.
  ///
  /// - parameters:
  ///   - client: the HTTP client to use for making network requests.
  init(client: HTTPResourceClientType) {
    self.client = client
  }

  /// Initialize this object.
  ///
  /// - parameters:
  ///   - url: the URL object used for creating client.
  convenience init(url: URL) {

    UpvestURLProtocol.register()
    let sessionConfig = URLSessionConfiguration.default
    var protos = sessionConfig.protocolClasses ?? []
    protos.insert(UpvestURLProtocol.self, at: 0)
    sessionConfig.protocolClasses = protos
    sessionConfig.timeoutIntervalForRequest = 5.0
    sessionConfig.timeoutIntervalForResource = 5.0
    let session = URLSession(configuration: sessionConfig)

    let client = HTTPResourceClient(baseURL: url, session: session)
    self.init(client: client)
  }

  /// Requests a resource from the Upvest API.
  ///
  /// Use this function when making a request that does not necessitate
  /// authentication (e.g. registering a device).
  ///
  /// - parameters:
  ///   - resource: the resource to request from the API
  ///   - completion: a closure to receive the result of the API request
  func request<A>(resource: HTTPResource<A>, completion: APICompletion<A>?) {
    request(resource: resource, behavior: nil, completion: completion)
  }

  /// Requests a resource from the Upvest API, using an authentication token.
  ///
  /// Use this function when making a request that does necessitate
  /// authentication (most do).
  ///
  /// - parameters:
  ///   - authToken: the authentication token to send along with this request
  ///   - resource: the resource to request from the API
  ///   - completion: a closure to receive the result of the API request
  func request<A>(authToken: String?, resource: HTTPResource<A>, completion: APICompletion<A>?) {
    let authTokenBehavior = AuthTokenBehavior(token: authToken)
    request(resource: resource, behavior: authTokenBehavior, completion: completion)
  }

  /// A helper method for requesting a resource via the API.
  ///
  /// - parameters:
  ///   - resource: the resource to request from the API
  ///   - behavior: an `HTTPBehavior` to use when making this request
  ///   - completion: a closure to receive the result of the API request
  private func request<A>(resource: HTTPResource<A>, behavior: HTTPBehavior?, completion: APICompletion<A>?) {
    client.request(resource: resource, behavior: behavior) { httpResult in
      completion?(httpResult)
    }
  }
}
