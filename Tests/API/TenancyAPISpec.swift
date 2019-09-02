//
//  TenancyAPISpec.swift
//  Upvest
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

// swiftlint:disable type_body_length function_body_length cyclomatic_complexity

import Foundation
import Nimble
import Quick
@testable import Upvest

class TenancyAPISpec: QuickSpec {

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

        context("cursor") {
            beforeEach {
                upvest.authManager.currentAuth = nil
            }
            describe("#next") {
                context("with success") {
                    it("hits the API and returns a CursorResult") {
                        let cannedResult = CursorResult<User>.sample()!
                        let currentResult = CursorResult<User>.sample()!
                        api.add(result: Result<CursorResult<User>, ResourceError>.success(cannedResult))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().cursor(currentResult).next() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        let currentResult = CursorResult<User>.sample()!
                        api.add(result: Result<CursorResult<User>, ResourceError>.failure(cannedError))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().cursor(currentResult).next() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // next

            describe("#previous") {
                context("with success") {
                    it("hits the API and returns a CursorResult") {
                        let cannedResult = CursorResult<User>.sample()!
                        let currentResult = CursorResult<User>.sample()!
                        api.add(result: Result<CursorResult<User>, ResourceError>.success(cannedResult))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().cursor(currentResult).previous() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        let currentResult = CursorResult<User>.sample()!
                        api.add(result: Result<CursorResult<User>, ResourceError>.failure(cannedError))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().cursor(currentResult).previous() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // previous
        }

        context("without auth") {
            beforeEach {
                upvest.authManager.currentAuth = nil
            }

            describe("#createUser") {
                context("with success") {
                    it("hits the API and returns a User") {
                        let cannedResult = User.sample()!
                        api.add(result: Result<User, ResourceError>.success(cannedResult))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().createUser(username: "John") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<User, ResourceError>.failure(cannedError))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().createUser(username: "John") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // createUser

            describe("#deleteUser") {
                context("with success") {
                    it("hits the API and returns 204") {
                        api.add(result: Result<Void, ResourceError>.success(()))

                        var error: UpvestError?
                        upvest.tenancy().deleteUser(username: "John") { (result) in
                            switch result {
                            case .success:
                                break
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<Void, ResourceError>.failure(cannedError))

                        var error: UpvestError?
                        upvest.tenancy().deleteUser(username: "John") { (result) in
                            switch result {
                            case .success:
                                break
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // deleteUser

            describe("#updateUserPassword") {
                context("with success") {
                    it("hits the API and returns a User") {
                        let cannedResult = User.sample()!
                        api.add(result: Result<User, ResourceError>.success(cannedResult))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().updateUserPassword(username: "John", oldPassword: "pass", newPassword: "new_pass") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<User, ResourceError>.failure(cannedError))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().updateUserPassword(username: "John", oldPassword: "pass", newPassword: "new_pass") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // updateUserPassword

            describe("#resetUserPassword") {
                context("with success") {
                    it("hits the API and returns a Result") {
                        let cannedResult = BasicResult(result: "Yay")
                        api.add(result: Result<BasicResult, ResourceError>.success(cannedResult))

                        var basicResult: BasicResult?
                        var error: UpvestError?
                        upvest.tenancy().resetUserPassword(username: "John", userId: "uid", seed: "seed", seedHash: "hash", newPassword: "newpass") { (result) in
                            switch result {
                            case .success(let result):
                                basicResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(basicResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<BasicResult, ResourceError>.failure(cannedError))

                        var basicResult: BasicResult?
                        var error: UpvestError?
                        upvest.tenancy().resetUserPassword(username: "John", userId: "uid", seed: "seed", seedHash: "hash", newPassword: "newpass") { (result) in
                            switch result {
                            case .success(let result):
                                basicResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(basicResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // resetUserPassword

            describe("#getUsers") {
                context("with success") {
                    it("hits the API and returns Users") {
                        let cannedResult = CursorResult<User>.sample()!
                        api.add(result: Result<CursorResult<User>, ResourceError>.success(cannedResult))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().getUsers() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<CursorResult<User>, ResourceError>.failure(cannedError))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().getUsers() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // getUsers

            describe("#getEcho") {
                context("with success") {
                    it("hits the API and returns an Echo") {
                        // add success result for get echo
                        let cannedEcho = Echo(echo: "Hello World")
                        api.add(result: Result<Echo, ResourceError>.success(cannedEcho))

                        var echoResult: Echo?
                        var errorResult: UpvestError?

                        upvest.tenancy().getEcho(echo: "echo", callback: { (result) in
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
                        upvest.tenancy().getEcho(echo: "echo", callback: { (result) in
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
                        upvest.tenancy().postEcho(echo: "echo", callback: { (result) in
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
                        upvest.tenancy().postEcho(echo: "echo", callback: { (result) in
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
        } // without auth

        context("with auth") {
            beforeEach {
                let storedCredential = UpvestOAuth.sample()
                upvest.authManager.currentAuth = storedCredential
            }

            describe("#createUser") {
                context("with success") {
                    it("hits the API and returns a User") {
                        let cannedResult = User.sample()!
                        api.add(result: Result<User, ResourceError>.success(cannedResult))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().createUser(username: "John") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<User, ResourceError>.failure(cannedError))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().createUser(username: "John") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // createUser

            describe("#deleteUser") {
                context("with success") {
                    it("hits the API and returns 204") {
                        api.add(result: Result<Void, ResourceError>.success(()))

                        var error: UpvestError?
                        upvest.tenancy().deleteUser(username: "John") { (result) in
                            switch result {
                            case .success:
                                break
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<Void, ResourceError>.failure(cannedError))

                        var error: UpvestError?
                        upvest.tenancy().deleteUser(username: "John") { (result) in
                            switch result {
                            case .success:
                                break
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // deleteUser

            describe("#updateUserPassword") {
                context("with success") {
                    it("hits the API and returns a User") {
                        let cannedResult = User.sample()!
                        api.add(result: Result<User, ResourceError>.success(cannedResult))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().updateUserPassword(username: "John", oldPassword: "pass", newPassword: "new_pass") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<User, ResourceError>.failure(cannedError))

                        var userResult: User?
                        var error: UpvestError?
                        upvest.tenancy().updateUserPassword(username: "John", oldPassword: "pass", newPassword: "new_pass") { (result) in
                            switch result {
                            case .success(let result):
                                userResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(userResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // updateUserPassword

            describe("#resetUserPassword") {
                context("with success") {
                    it("hits the API and returns a Result") {
                        let cannedResult = BasicResult(result: "Yay")
                        api.add(result: Result<BasicResult, ResourceError>.success(cannedResult))

                        var basicResult: BasicResult?
                        var error: UpvestError?
                        upvest.tenancy().resetUserPassword(username: "John", userId: "uid", seed: "seed", seedHash: "hash", newPassword: "newpass") { (result) in
                            switch result {
                            case .success(let result):
                                basicResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(basicResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<BasicResult, ResourceError>.failure(cannedError))

                        var basicResult: BasicResult?
                        var error: UpvestError?
                        upvest.tenancy().resetUserPassword(username: "John", userId: "uid", seed: "seed", seedHash: "hash", newPassword: "newpass") { (result) in
                            switch result {
                            case .success(let result):
                                basicResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(basicResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // resetUserPassword

            describe("#getUsers") {
                context("with success") {
                    it("hits the API and returns a Users") {
                        let cannedResult = CursorResult<User>.sample()!
                        api.add(result: Result<CursorResult<User>, ResourceError>.success(cannedResult))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().getUsers() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<CursorResult<User>, ResourceError>.failure(cannedError))

                        var usersResult: CursorResult<User>?
                        var error: UpvestError?
                        upvest.tenancy().getUsers() { (result) in
                            switch result {
                            case .success(let result):
                                usersResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(usersResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // getUsers

            describe("#getEcho") {
                context("with success") {
                    it("hits the API and returns an Echo") {
                        // add success result for get echo
                        let cannedEcho = Echo(echo: "Hello World")
                        api.add(result: Result<Echo, ResourceError>.success(cannedEcho))

                        var echoResult: Echo?
                        var errorResult: UpvestError?

                        upvest.tenancy().getEcho(echo: "echo", callback: { (result) in
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
                        upvest.tenancy().getEcho(echo: "echo", callback: { (result) in
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
                        upvest.tenancy().postEcho(echo: "echo", callback: { (result) in
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
