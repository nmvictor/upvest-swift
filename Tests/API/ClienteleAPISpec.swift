//
//  ClienteleAPISpec.swift
//  Upvest
//
//  Created by Moin' Victor on 22/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

// swiftlint:disable type_body_length function_body_length cyclomatic_complexity

import Foundation
import Nimble
import Quick
@testable import Upvest

class ClienteleAPISpec: QuickSpec {

    override func spec() {
        var api: StubUpvestAPI!
        var upvest: Upvest!

        beforeEach {

            api = StubUpvestAPI()
            let config = UpvestConfiguration.sample()
            upvest = StubUpvestWithMockStorage(configuration: config)
            upvest.configuration = config
            upvest.api = api
        }

        context("without auth") {
            beforeEach {
                upvest.authManager.currentAuth = nil
            }

            describe("#authenticate") {
                context("with success") {
                    it("hits the API and returns a Credential") {
                        let cannedCredential = UpvestOAuth.sample()
                        api.add(result: Result<UpvestOAuth, ResourceError>.success(cannedCredential))

                        var authResult: UpvestOAuth?
                        var error: UpvestError?
                        upvest.clientele().authenticate(username: "user", password: "pass", callback: { (result) in
                            switch result {
                            case .success(let auth):
                                authResult = auth
                            case .failure(let err):
                                error = err
                            }
                        })

                        expect(authResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<UpvestOAuth, ResourceError>.failure(cannedError))

                        var authResult: UpvestOAuth?
                        var error: UpvestError?
                        upvest.clientele().authenticate(username: "user", password: "pass", callback: { (result) in
                            switch result {
                            case .success(let auth):
                                authResult = auth
                            case .failure(let err):
                                error = err
                            }
                        })

                        expect(authResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // authenticate

            describe("#getEcho") {
                it("returns an error without hitting the API") {
                    let cannedEcho = Echo(echo: "Hello World")
                    api.add(result: Result<Echo, ResourceError>.success(cannedEcho))

                    var echoResult: Echo?
                    var errorResult: Error?
                    upvest.clientele().getEcho(echo: "echo", callback: { (result) in
                        switch result {
                        case .success(let echo):
                            echoResult = echo
                        case .failure(let err):
                            errorResult = err
                        }
                    })

                    expect(echoResult).toEventually(beNil())
                    expect(errorResult).toEventually(matchError(UpvestError.noCredentials))
                }
            } // getEcho

            describe("#postEcho") {
                it("returns an error without hitting the API") {
                    let cannedEcho = Echo(echo: "Hello World")
                    api.add(result: Result<Echo, ResourceError>.success(cannedEcho))

                    var echoResult: Echo?
                    var errorResult: Error?
                    upvest.clientele().postEcho(echo: "echo", callback: { (result) in
                        switch result {
                        case .success(let echo):
                            echoResult = echo
                        case .failure(let err):
                            errorResult = err
                        }
                    })

                    expect(echoResult).toEventually(beNil())
                    expect(errorResult).toEventually(matchError(UpvestError.noCredentials))
                }
            } // postEcho

        } // without auth

        context("with auth") {
            beforeEach {
                let storedCredential = UpvestOAuth.sample()
                upvest.authManager.currentAuth = storedCredential
            }
            describe("#getEcho") {
                context("with success") {
                    it("hits the API and returns an Echo") {
                        // add success result for get echo
                        let cannedEcho = Echo(echo: "Hello World")
                        api.add(result: Result<Echo, ResourceError>.success(cannedEcho))

                        var echoResult: Echo?
                        var errorResult: UpvestError?
                        upvest.clientele().getEcho(echo: "echo", callback: { (result) in
                            switch result {
                            case .success(let echo):
                                echoResult = echo
                            case .failure(let err):
                                errorResult = err
                            }
                        })
                        expect(echoResult).toEventuallyNot(beNil())
                        expect(errorResult).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        // add error result for get repos
                        let cannedError: ResourceError = .noData
                        api.add(result: Result<Echo, ResourceError>.failure(cannedError))
                        var echoResult: Echo?
                        var errorResult: Error?
                        upvest.clientele().getEcho(echo: "echo", callback: { (result) in
                            switch result {
                            case .success(let echo):
                                echoResult = echo
                            case .failure(let err):
                                errorResult = err
                            }
                        })
                        expect(echoResult).toEventually(beNil())
                        expect(errorResult).toEventually(matchError(UpvestError.other("no data")))
                    }
                } // with failure
            } // getEcho

            describe("#postEcho") {
                context("with success") {
                    it("hits the API and returns an Echo") {
                        // add success result for get echo
                        let cannedEcho = Echo(echo: "Hello World")
                        api.add(result: Result<Echo, ResourceError>.success(cannedEcho))

                        var echoResult: Echo?
                        var errorResult: UpvestError?
                        upvest.clientele().postEcho(echo: "echo", callback: { (result) in
                            switch result {
                            case .success(let echo):
                                echoResult = echo
                            case .failure(let err):
                                errorResult = err
                            }
                        })
                        expect(echoResult).toEventuallyNot(beNil())
                        expect(errorResult).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        // add error result for get repos
                        let cannedError: ResourceError = .noData
                        api.add(result: Result<Echo, ResourceError>.failure(cannedError))
                        var echoResult: Echo?
                        var errorResult: Error?
                        upvest.clientele().postEcho(echo: "echo", callback: { (result) in
                            switch result {
                            case .success(let echo):
                                echoResult = echo
                            case .failure(let err):
                                errorResult = err
                            }
                        })
                        expect(echoResult).toEventually(beNil())
                        expect(errorResult).toEventually(matchError(UpvestError.other("no data")))
                    }
                } // with failure
            } // postEcho

        } // with auth
    } // spec

} // class
