//
//  UpvestURLProtocol.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

/// A custom URLProtocol implementation to add logging of HTTP requests, 
/// responses, and errors in an aspect-oriented way.
class UpvestURLProtocol: URLProtocol {

  /// A key to indicate that a request has already been marked as handled by
  /// this protocol implementation.
  fileprivate static let handledKey = "handled"

  /// The connection to use for HTTP requests
  fileprivate var connection: URLSessionDataTask?

  /// The data received from the connection
  fileprivate var data: Data?

  /// The response to the HTTP request
  fileprivate var response: URLResponse?

  /// A copy of the request we are being asked to handle
  fileprivate var newRequest: NSMutableURLRequest!

  /// Registers this protocol class as a URLProtocol.
  class func register() {
    URLProtocol.registerClass(self)
  }

  /// Un-registers this protocol class as a URLProtocol.
  class func unregister() {
    URLProtocol.unregisterClass(self)
  }

  /// Determines if this URLProtocol can handle a given request.
  ///
  /// - parameters:
  ///   - request: the URLRequest in question
  override class func canInit(with request: URLRequest) -> Bool {
    guard self.property(forKey: UpvestURLProtocol.handledKey, in: request) == nil else {
      return false
    }

    return true
  }

  /// Determines the canonical request for a given request.
  ///
  /// - parameters:
  ///   - request: the URLRequest in question
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  /// Starts loading the request in question.
  override func startLoading() {
    guard let req = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest, newRequest == nil else { return }

    self.newRequest = req

    UpvestURLProtocol.setProperty(true, forKey: UpvestURLProtocol.handledKey, in: newRequest!)
    connection = URLSession.shared.dataTask(with: newRequest as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            self.client?.urlProtocol(self, didFailWithError: error as NSError)
            print("Request Error: \n\(error.localizedDescription)")
            return
        } else if let response = response {
            let policy = URLCache.StoragePolicy(rawValue: self.request.cachePolicy.rawValue) ?? .notAllowed
            self.response = response
            self.data = Data()
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: policy)
            self.client?.urlProtocolDidFinishLoading(self)
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
                self.data?.append(data)
            }
            print("Request Response: \(response), \n\(data?.toString() ?? "")")
        }
    })
    connection?.resume()

  }

  /// Stops loading the request in question.
  override func stopLoading() {
    connection?.cancel()
    connection = nil
  }
}
