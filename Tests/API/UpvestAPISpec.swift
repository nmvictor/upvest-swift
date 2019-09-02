//
//  UpvestAPISpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 15/08/2019.
//  Copyright © 2019 Moin' Victor. All rights reserved.
//

// swiftlint:disable type_body_length cyclomatic_complexity

import Foundation
@testable import Upvest
import Nimble
import Quick

class UpvestAPISpec: QuickSpec {
    override func spec() {
        describe("#request") {
            let cannedResult = Result<String, ResourceError>.success("OK")
            let client = StubHTTPResourceClient(result: cannedResult)
            let api = UpvestAPI(client: client)
            let resource = HTTPResource(path: "/") { _ in "" }

            var string: String?

            context("without auth token") {
                it("requests via the HTTP client") {
                    api.request(resource: resource) { result in
                        if case let .success(value) = result {
                            string = value
                        }
                    }

                    expect(client.behaviorUsed).to(beNil())
                    expect(string).toEventually(equal("OK"))
                }
            }

            context("with auth token") {
                it("requests via the HTTP client using a behavior") {
                    api.request(authToken: "secret-token", resource: resource) { result in
                        if case let .success(value) = result {
                            string = value
                        }
                    }

                    expect(client.behaviorUsed).to(beAnInstanceOf(AuthTokenBehavior.self))
                    expect(string).toEventually(equal("OK"))
                }
            }
        }
    }
}
