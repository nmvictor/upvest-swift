//
//  HTTPExecutor.swift
//  UpvestTests
//
//  Created by Moin' Victor on 2/22/18.
//  Copyright © 2019 Upvest. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Upvest

class BaseOperationSpec: QuickSpec {

    override func spec() {
        var api: StubUpvestAPI!
        var upvest: Upvest!
        var creds: UpvestOAuth!

        beforeEach {
            api = StubUpvestAPI()
            let config = UpvestConfiguration.sample()
            upvest = StubUpvestWithMockStorage(configuration: config)
            Upvest.configure(configuration: config)
            upvest.api = api
            creds = UpvestOAuth(accessToken: "zSMWkPGyMatY8oYVsFEv1Pr9sjMS3Q", tokenType: "Bearer", scope: "read write echo wallet transaction", expiresIn: 1300, refreshToken: "iYmTFUisTiNSwdwFaNQ63U1a6bOBNs")
            upvest.authManager.currentAuth = creds

        }

        describe("when error is 'unreachable'") {
            it("retries the request up to the maximum number of times") {
                let cannedResult = Result<UpvestOAuth, ResourceError>.failure(.unreachable)
                let client = StubHTTPResourceClient(result: cannedResult)
                let api = UpvestAPI(client: client)
                let configuration = UpvestConfiguration.sample()
                let instance = Upvest(configuration: configuration)
                instance.api = api

                instance.clientele().authenticate(username: "user", password: "password")

                expect(client.retry).toEventually(equal(4))
            }
        }

        describe("when error is not 'unreachable'") {
            it("does not retry the request") {
                let cannedResult = Result<UpvestOAuth, ResourceError>.failure(.other(nil))
                let client = StubHTTPResourceClient(result: cannedResult)
                let api = UpvestAPI(client: client)
                let configuration = UpvestConfiguration.sample()
                let instance = Upvest(configuration: configuration)
                instance.api = api
                
                instance.clientele().authenticate(username: "user", password: "password")

                expect(client.retry).toEventually(equal(1))
            }
        }

        describe("when there's an 'unauthorized'") {
            it("will make an auth request and before getting back to the original") {
                let cannedResult = Result<[Repository], ResourceError>.failure(.unauthorized)
                let authResult = Result<UpvestOAuth, ResourceError>.success(creds)
                let regPushSuccessResult = Result<[Repository], ResourceError>.success([])
                api.add(result: cannedResult)
                api.add(result: authResult)
                api.add(result: regPushSuccessResult)

                upvest.getUserRepositories({ (result) in

                })

                expect(api.retry).toEventually(equal(3))
            }

            it("will make an auth request and retry the original up the max number of times") {
                let cannedResult = Result<[Repository], ResourceError>.failure(.unauthorized)
                let authResult = Result<UpvestOAuth, ResourceError>.success(creds)
                let regPushFailureResult = Result<[Repository], ResourceError>.failure(.unreachable)
                let regPushSuccessResult = Result<[Repository], ResourceError>.success([])
                api.add(result: cannedResult)
                api.add(result: authResult)
                api.add(result: regPushFailureResult)
                api.add(result: regPushFailureResult)
                api.add(result: regPushSuccessResult)

                upvest.getUserRepositories({ (result) in

                })

                expect(api.retry).toEventually(equal(5))
            }

            it("will give up after getting two another 'unauthorized'") {
                let unauthorized = Result<[Repository], ResourceError>.failure(.unauthorized)
                let authResult = Result<UpvestOAuth, ResourceError>.failure(.unauthorized)
                api.add(result: unauthorized)
                api.add(result: authResult)

                upvest.getUserRepositories({ (result) in

                })

                expect(api.retry).toEventually(equal(2))
            }
        }
    }
}
