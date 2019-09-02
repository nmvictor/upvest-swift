//
//  AssetsAPISpec.swift
//  Upvest
//
//  Created by Moin' Victor on 28/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

// swiftlint:disable type_body_length function_body_length cyclomatic_complexity

import Foundation
import Nimble
import Quick
@testable import Upvest

class AssetsAPISpec: QuickSpec {

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

            describe("#getAssetInfo") {
                it("returns an error without hitting the API") {
                    let cannedResult = Asset.sample()!
                    api.add(result: Result<Asset, ResourceError>.success(cannedResult))

                    var assetResult: Asset?
                    var error: UpvestError?
                    upvest.assets().getAsset(byId: "A-ID") { (result) in
                        switch result {
                        case .success(let result):
                            assetResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(assetResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }
            } // getAssetInfo

            describe("#list") {
                it("returns an error without hitting the API") {
                    let cannedResult = CursorResult<Asset>.sample()!
                    api.add(result: Result<CursorResult<Asset>, ResourceError>.success(cannedResult))

                    var assetsResult: CursorResult<Asset>?
                    var error: UpvestError?
                    upvest.assets().list() { (result) in
                        switch result {
                        case .success(let result):
                            assetsResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(assetsResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }

            } // list

            context("cursor") {

                describe("#next") {
                    it("returns an error without hitting the API") {
                        let cannedResult = CursorResult<Asset>.sample()!
                        let currentResult = CursorResult<Asset>.sample()!
                        api.add(result: Result<CursorResult<Asset>, ResourceError>.success(cannedResult))

                        var assetsResult: CursorResult<Asset>?
                        var error: UpvestError?
                        upvest.assets().cursor(currentResult).next() { (result) in
                            switch result {
                            case .success(let result):
                                assetsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(assetsResult).toEventually(beNil())
                        expect(error).toEventually(matchError(UpvestError.noCredentials))
                    }
                } // next

                describe("#previous") {
                    it("returns an error without hitting the API") {
                        let cannedResult = CursorResult<Asset>.sample()!
                        let currentResult = CursorResult<Asset>.sample()!
                        api.add(result: Result<CursorResult<Asset>, ResourceError>.success(cannedResult))

                        var assetsResult: CursorResult<Asset>?
                        var error: UpvestError?
                        upvest.assets().cursor(currentResult).previous() { (result) in
                            switch result {
                            case .success(let result):
                                assetsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(assetsResult).toEventually(beNil())
                        expect(error).toEventually(matchError(UpvestError.noCredentials))
                    }
                } // previous
            } // cursor
        } // without auth

        context("with auth") {
            beforeEach {
                let storedCredential = UpvestOAuth.sample()
                upvest.authManager.currentAuth = storedCredential
            }

            describe("#getAssetInfo") {
                context("with success") {
                    it("hits the API and returns Asset Info") {
                        let cannedResult = Asset.sample()!
                        api.add(result: Result<Asset, ResourceError>.success(cannedResult))

                        var assetResult: Asset?
                        var error: UpvestError?
                        upvest.assets().getAsset(byId: "A-ID") { (result) in
                            switch result {
                            case .success(let result):
                                assetResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(assetResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<Asset, ResourceError>.failure(cannedError))

                        var assetResult: Asset?
                        var error: UpvestError?
                        upvest.assets().getAsset(byId: "A-ID") { (result) in
                            switch result {
                            case .success(let result):
                                assetResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(assetResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // getAssetInfo

            describe("#list") {
                context("with success") {
                    it("hits the API and returns Assets") {
                        let cannedResult = CursorResult<Asset>.sample()!
                        api.add(result: Result<CursorResult<Asset>, ResourceError>.success(cannedResult))

                        var assetsResult: CursorResult<Asset>?
                        var error: UpvestError?
                        upvest.assets().list() { (result) in
                            switch result {
                            case .success(let result):
                                assetsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(assetsResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<CursorResult<Asset>, ResourceError>.failure(cannedError))

                        var assetsResult: CursorResult<Asset>?
                        var error: UpvestError?
                        upvest.assets().list() { (result) in
                            switch result {
                            case .success(let result):
                                assetsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(assetsResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // list

            context("cursor") {

                describe("#next") {
                    context("with success") {
                        it("hits the API and returns a CursorResult") {
                            let cannedResult = CursorResult<Asset>.sample()!
                            let currentResult = CursorResult<Asset>.sample()!
                            api.add(result: Result<CursorResult<Asset>, ResourceError>.success(cannedResult))

                            var assetsResult: CursorResult<Asset>?
                            var error: UpvestError?
                            upvest.assets().cursor(currentResult).next() { (result) in
                                switch result {
                                case .success(let result):
                                    assetsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(assetsResult).toEventuallyNot(beNil())
                            expect(error).toEventually(beNil())
                        }
                    } // with success

                    context("with failure") {
                        it("hits the API and returns an error") {
                            let cannedError = ResourceError.noData
                            let currentResult = CursorResult<Asset>.sample()!
                            api.add(result: Result<CursorResult<Asset>, ResourceError>.failure(cannedError))

                            var assetsResult: CursorResult<Asset>?
                            var error: UpvestError?
                            upvest.assets().cursor(currentResult).next() { (result) in
                                switch result {
                                case .success(let result):
                                    assetsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(assetsResult).toEventually(beNil())
                            expect(error).toEventuallyNot(beNil())
                            expect(error).toEventually(matchError(UpvestError.self))
                        }
                    } // with failure
                } // next

                describe("#previous") {
                    context("with success") {
                        it("hits the API and returns a CursorResult") {
                            let cannedResult = CursorResult<Asset>.sample()!
                            let currentResult = CursorResult<Asset>.sample()!
                            api.add(result: Result<CursorResult<Asset>, ResourceError>.success(cannedResult))

                            var assetsResult: CursorResult<Asset>?
                            var error: UpvestError?
                            upvest.assets().cursor(currentResult).previous() { (result) in
                                switch result {
                                case .success(let result):
                                    assetsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(assetsResult).toEventuallyNot(beNil())
                            expect(error).toEventually(beNil())
                        }
                    } // with success

                    context("with failure") {
                        it("hits the API and returns an error") {
                            let cannedError = ResourceError.noData
                            let currentResult = CursorResult<Asset>.sample()!
                            api.add(result: Result<CursorResult<Asset>, ResourceError>.failure(cannedError))

                            var assetsResult: CursorResult<Asset>?
                            var error: UpvestError?
                            upvest.assets().cursor(currentResult).previous() { (result) in
                                switch result {
                                case .success(let result):
                                    assetsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(assetsResult).toEventually(beNil())
                            expect(error).toEventuallyNot(beNil())
                            expect(error).toEventually(matchError(UpvestError.self))
                        }
                    } // with failure
                } // previous
            } // cursor
        } // with auth
    } // spec

} // class
