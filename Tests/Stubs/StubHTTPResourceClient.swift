//
//  StubHTTPResourceClient.swift
//  UpvestTests
//
//  Created by Moin' Victor on 15/08/2019.
//  Copyright © 2019 Moin' Victor. All rights reserved.
//

@testable import Upvest

class StubHTTPResourceClient: HTTPResourceClientType {
  let result: Any
  var retry = 0
  var behaviorUsed: HTTPBehavior?

  init(result: Any) {
    self.result = result
  }

  func request<A>(resource: HTTPResource<A>, behavior: HTTPBehavior?, completion: HTTPCompletion<A>?) {
    guard let result = self.result as? Result<A, ResourceError> else {
      fatalError("Could not convert \(self.result) to type: \(A.self)")
    }
    self.behaviorUsed = behavior

    completion?(result)
    retry += 1
  }
}
