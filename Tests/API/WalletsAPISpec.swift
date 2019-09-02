//
//  WalletsAPISpec.swift
//  Upvest
//
//  Created by Moin' Victor on 30/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

// swiftlint:disable type_body_length function_body_length cyclomatic_complexity

import Foundation
import Nimble
import Quick
@testable import Upvest

class WalletsAPISpec: QuickSpec {

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

            describe("#createWallet") {
                it("returns an error without hitting the API") {
                    let cannedResult = Wallet.sample()!
                    api.add(result: Result<Wallet, ResourceError>.success(cannedResult))

                    var walletResult: Wallet?
                    var error: UpvestError?
                    upvest.wallets().createWallet(assetId: "A-ID", index: 0, password: "pass") { (result) in
                        switch result {
                        case .success(let result):
                            walletResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(walletResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }
            } // createWallet

            describe("#signWithWallet") {
                it("returns an error without hitting the API") {
                    let cannedResult = SignedWithWalletResult.sample()!
                    api.add(result: Result<SignedWithWalletResult, ResourceError>.success(cannedResult))

                    var successResult: SignedWithWalletResult?
                    var error: UpvestError?
                    upvest.wallets().sign("my-hash", withWallet: "w-id", inputFormat: .base64, outputFormat: .base64BigEndian, password: "pass") { (result) in
                        switch result {
                        case .success(let result):
                            successResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(successResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }
            } // signWithWallet

            describe("#getWalletById") {
                it("returns an error without hitting the API") {
                    let cannedResult = Wallet.sample()!
                    api.add(result: Result<Wallet, ResourceError>.success(cannedResult))

                    var walletResult: Wallet?
                    var error: UpvestError?
                    upvest.wallets().getWallet(byId: "W-ID") { (result) in
                        switch result {
                        case .success(let result):
                            walletResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(walletResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }
            } // getWalletbyId

            describe("#list") {
                it("returns an error without hitting the API") {
                    let cannedResult = CursorResult<Wallet>.sample()!
                    api.add(result: Result<CursorResult<Wallet>, ResourceError>.success(cannedResult))

                    var walletsResult: CursorResult<Wallet>?
                    var error: UpvestError?
                    upvest.wallets().list() { (result) in
                        switch result {
                        case .success(let result):
                            walletsResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(walletsResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }

            } // list

            context("cursorWallet") {

                describe("#next") {
                    it("returns an error without hitting the API") {
                        let cannedResult = CursorResult<Wallet>.sample()!
                        let currentResult = CursorResult<Wallet>.sample()!
                        api.add(result: Result<CursorResult<Wallet>, ResourceError>.success(cannedResult))

                        var walletsResult: CursorResult<Wallet>?
                        var error: UpvestError?
                        upvest.wallets().cursor(currentResult).next() { (result) in
                            switch result {
                            case .success(let result):
                                walletsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletsResult).toEventually(beNil())
                        expect(error).toEventually(matchError(UpvestError.noCredentials))
                    }
                } // next

                describe("#previous") {
                    it("returns an error without hitting the API") {
                        let cannedResult = CursorResult<Wallet>.sample()!
                        let currentResult = CursorResult<Wallet>.sample()!
                        api.add(result: Result<CursorResult<Wallet>, ResourceError>.success(cannedResult))

                        var walletsResult: CursorResult<Wallet>?
                        var error: UpvestError?
                        upvest.wallets().cursor(currentResult).previous() { (result) in
                            switch result {
                            case .success(let result):
                                walletsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletsResult).toEventually(beNil())
                        expect(error).toEventually(matchError(UpvestError.noCredentials))
                    }
                } // previous
            } // cursorWallet

            describe("#createTransaction") {
                it("returns an error without hitting the API") {
                    let cannedResult = Transaction.sample()!
                    api.add(result: Result<Transaction, ResourceError>.success(cannedResult))

                    var tranxResult: Transaction?
                    var error: UpvestError?
                    upvest.wallets().createTransaction(walletId: "w-id", assetId: "a-id", quantity: "100", fee: "10", password: "pass") { (result) in
                        switch result {
                        case .success(let result):
                            tranxResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(tranxResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }
            } // createTransaction

            describe("#getTransactionById") {
                it("returns an error without hitting the API") {
                    let cannedResult = Transaction.sample()!
                    api.add(result: Result<Transaction, ResourceError>.success(cannedResult))

                    var tranxResult: Transaction?
                    var error: UpvestError?
                    upvest.wallets().getTransaction(forWallet: "w-id", tranxId: "tranx-id") { (result) in
                        switch result {
                        case .success(let result):
                            tranxResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(tranxResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }
            } // getTransactionInfo

            describe("#listTransactions") {
                it("returns an error without hitting the API") {
                    let cannedResult = CursorResult<Transaction>.sample()!
                    api.add(result: Result<CursorResult<Transaction>, ResourceError>.success(cannedResult))

                    var tranxResult: CursorResult<Transaction>?
                    var error: UpvestError?
                    upvest.wallets().listTransactions(forWallet: "w-id") { (result) in
                        switch result {
                        case .success(let result):
                            tranxResult = result
                        case .failure(let err):
                            error = err
                        }
                    }

                    expect(tranxResult).toEventually(beNil())
                    expect(error).toEventually(matchError(UpvestError.noCredentials))
                }

            } // listTransactions

            context("cursorTranx") {

                describe("#next") {
                    it("returns an error without hitting the API") {
                        let cannedResult = CursorResult<Transaction>.sample()!
                        let currentResult = CursorResult<Transaction>.sample()!
                        api.add(result: Result<CursorResult<Transaction>, ResourceError>.success(cannedResult))

                        var tranxResult: CursorResult<Transaction>?
                        var error: UpvestError?
                        upvest.wallets().cursor(currentResult).next() { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventually(beNil())
                        expect(error).toEventually(matchError(UpvestError.noCredentials))
                    }
                } // next

                describe("#previous") {
                    it("returns an error without hitting the API") {
                        let cannedResult = CursorResult<Transaction>.sample()!
                        let currentResult = CursorResult<Transaction>.sample()!
                        api.add(result: Result<CursorResult<Transaction>, ResourceError>.success(cannedResult))

                        var tranxResult: CursorResult<Transaction>?
                        var error: UpvestError?
                        upvest.wallets().cursor(currentResult).previous() { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventually(beNil())
                        expect(error).toEventually(matchError(UpvestError.noCredentials))
                    }
                } // previous
            } // cursorTranx
        } // without auth

        context("with auth") {
            beforeEach {
                let storedCredential = UpvestOAuth.sample()
                upvest.authManager.currentAuth = storedCredential
            }

            describe("#createWallet") {
                context("with success") {
                    it("hits the API and returns a Wallet") {
                        let cannedResult = Wallet.sample()!
                        api.add(result: Result<Wallet, ResourceError>.success(cannedResult))

                        var walletResult: Wallet?
                        var error: UpvestError?
                        upvest.wallets().createWallet(assetId: "A-ID", index: 0, password: "pass") { (result) in
                            switch result {
                            case .success(let result):
                                walletResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<Wallet, ResourceError>.failure(cannedError))

                        var walletResult: Wallet?
                        var error: UpvestError?
                        upvest.wallets().createWallet(assetId: "A-ID", index: 0, password: "pass") { (result) in
                            switch result {
                            case .success(let result):
                                walletResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // createWallet

            describe("#signWithWallet") {
                context("with success") {
                    it("hits the API and returns a Wallet") {
                        let cannedResult = SignedWithWalletResult.sample()!
                        api.add(result: Result<SignedWithWalletResult, ResourceError>.success(cannedResult))

                        var successResult: SignedWithWalletResult?
                        var error: UpvestError?
                        upvest.wallets().sign("my-hash", withWallet: "w-id", inputFormat: .base64, outputFormat: .base64BigEndian, password: "pass") { (result) in
                            switch result {
                            case .success(let result):
                                successResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(successResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<SignedWithWalletResult, ResourceError>.failure(cannedError))

                        var successResult: SignedWithWalletResult?
                        var error: UpvestError?
                        upvest.wallets().sign("my-hash", withWallet: "w-id", inputFormat: .base64, outputFormat: .base64BigEndian, password: "pass") { (result) in
                            switch result {
                            case .success(let result):
                                successResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(successResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // signWithWallet

            describe("#getWalletById") {
                context("with success") {
                    it("hits the API and returns Wallet Info") {
                        let cannedResult = Wallet.sample()!
                        api.add(result: Result<Wallet, ResourceError>.success(cannedResult))

                        var walletResult: Wallet?
                        var error: UpvestError?
                        upvest.wallets().getWallet(byId: "W-ID") { (result) in
                            switch result {
                            case .success(let result):
                                walletResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<Wallet, ResourceError>.failure(cannedError))

                        var walletResult: Wallet?
                        var error: UpvestError?
                        upvest.wallets().getWallet(byId: "W-ID") { (result) in
                            switch result {
                            case .success(let result):
                                walletResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // getWalletbyId

            describe("#list") {
                context("with success") {
                    it("hits the API and returns Wallets") {
                        let cannedResult = CursorResult<Wallet>.sample()!
                        api.add(result: Result<CursorResult<Wallet>, ResourceError>.success(cannedResult))

                        var walletsResult: CursorResult<Wallet>?
                        var error: UpvestError?
                        upvest.wallets().list() { (result) in
                            switch result {
                            case .success(let result):
                                walletsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletsResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<CursorResult<Wallet>, ResourceError>.failure(cannedError))

                        var walletsResult: CursorResult<Wallet>?
                        var error: UpvestError?
                        upvest.wallets().list() { (result) in
                            switch result {
                            case .success(let result):
                                walletsResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(walletsResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // list

            context("cursor") {

                describe("#next") {
                    context("with success") {
                        it("hits the API and returns a CursorResult") {
                            let cannedResult = CursorResult<Wallet>.sample()!
                            let currentResult = CursorResult<Wallet>.sample()!
                            api.add(result: Result<CursorResult<Wallet>, ResourceError>.success(cannedResult))

                            var walletsResult: CursorResult<Wallet>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).next() { (result) in
                                switch result {
                                case .success(let result):
                                    walletsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(walletsResult).toEventuallyNot(beNil())
                            expect(error).toEventually(beNil())
                        }
                    } // with success

                    context("with failure") {
                        it("hits the API and returns an error") {
                            let cannedError = ResourceError.noData
                            let currentResult = CursorResult<Wallet>.sample()!
                            api.add(result: Result<CursorResult<Wallet>, ResourceError>.failure(cannedError))

                            var walletsResult: CursorResult<Wallet>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).next() { (result) in
                                switch result {
                                case .success(let result):
                                    walletsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(walletsResult).toEventually(beNil())
                            expect(error).toEventuallyNot(beNil())
                            expect(error).toEventually(matchError(UpvestError.self))
                        }
                    } // with failure
                } // next

                describe("#previous") {
                    context("with success") {
                        it("hits the API and returns a CursorResult") {
                            let cannedResult = CursorResult<Wallet>.sample()!
                            let currentResult = CursorResult<Wallet>.sample()!
                            api.add(result: Result<CursorResult<Wallet>, ResourceError>.success(cannedResult))

                            var walletsResult: CursorResult<Wallet>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).previous() { (result) in
                                switch result {
                                case .success(let result):
                                    walletsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(walletsResult).toEventuallyNot(beNil())
                            expect(error).toEventually(beNil())
                        }
                    } // with success

                    context("with failure") {
                        it("hits the API and returns an error") {
                            let cannedError = ResourceError.noData
                            let currentResult = CursorResult<Wallet>.sample()!
                            api.add(result: Result<CursorResult<Wallet>, ResourceError>.failure(cannedError))

                            var walletsResult: CursorResult<Wallet>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).previous() { (result) in
                                switch result {
                                case .success(let result):
                                    walletsResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(walletsResult).toEventually(beNil())
                            expect(error).toEventuallyNot(beNil())
                            expect(error).toEventually(matchError(UpvestError.self))
                        }
                    } // with failure
                } // previous
            } // cursor

            describe("#createTransaction") {
                context("with success") {
                    it("hits the API and returns a Transaction") {
                        let cannedResult = Transaction.sample()!
                        api.add(result: Result<Transaction, ResourceError>.success(cannedResult))

                        var tranxResult: Transaction?
                        var error: UpvestError?
                        upvest.wallets().createTransaction(walletId: "w-id", assetId: "a-id", quantity: "100", fee: "10", password: "pass") { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<Transaction, ResourceError>.failure(cannedError))

                        var tranxResult: Transaction?
                        var error: UpvestError?
                        upvest.wallets().createTransaction(walletId: "w-id", assetId: "a-id", quantity: "100", fee: "10", password: "pass") { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // createTransaction

            describe("#getTransactionById") {
                context("with success") {
                    it("hits the API and returns Transaction Info") {
                        let cannedResult = Transaction.sample()!
                        api.add(result: Result<Transaction, ResourceError>.success(cannedResult))

                        var tranxResult: Transaction?
                        var error: UpvestError?
                        upvest.wallets().getTransaction(forWallet: "w-id", tranxId: "tranx-id") { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<Transaction, ResourceError>.failure(cannedError))

                        var tranxResult: Transaction?
                        var error: UpvestError?
                        upvest.wallets().getTransaction(forWallet: "w-id", tranxId: "tranx-id") { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // getTransactionById

            describe("#listTransactions") {
                context("with success") {
                    it("hits the API and returns Transactions") {
                        let cannedResult = CursorResult<Transaction>.sample()!
                        api.add(result: Result<CursorResult<Transaction>, ResourceError>.success(cannedResult))

                        var tranxResult: CursorResult<Transaction>?
                        var error: UpvestError?
                        upvest.wallets().listTransactions(forWallet: "w-id") { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventuallyNot(beNil())
                        expect(error).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        let cannedError = ResourceError.noData
                        api.add(result: Result<CursorResult<Transaction>, ResourceError>.failure(cannedError))

                        var tranxResult: CursorResult<Transaction>?
                        var error: UpvestError?
                        upvest.wallets().listTransactions(forWallet: "w-id") { (result) in
                            switch result {
                            case .success(let result):
                                tranxResult = result
                            case .failure(let err):
                                error = err
                            }
                        }

                        expect(tranxResult).toEventually(beNil())
                        expect(error).toEventuallyNot(beNil())
                        expect(error).toEventually(matchError(UpvestError.self))
                    }
                } // with failure
            } // listTransactions

            context("cursorTranx") {

                describe("#next") {
                    context("with success") {
                        it("hits the API and returns a CursorResult") {
                            let cannedResult = CursorResult<Transaction>.sample()!
                            let currentResult = CursorResult<Transaction>.sample()!
                            api.add(result: Result<CursorResult<Transaction>, ResourceError>.success(cannedResult))

                            var tranxResult: CursorResult<Transaction>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).next() { (result) in
                                switch result {
                                case .success(let result):
                                    tranxResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(tranxResult).toEventuallyNot(beNil())
                            expect(error).toEventually(beNil())
                        }
                    } // with success

                    context("with failure") {
                        it("hits the API and returns an error") {
                            let cannedError = ResourceError.noData
                            let currentResult = CursorResult<Transaction>.sample()!
                            api.add(result: Result<CursorResult<Transaction>, ResourceError>.failure(cannedError))

                            var tranxResult: CursorResult<Transaction>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).next() { (result) in
                                switch result {
                                case .success(let result):
                                    tranxResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(tranxResult).toEventually(beNil())
                            expect(error).toEventuallyNot(beNil())
                            expect(error).toEventually(matchError(UpvestError.self))
                        }
                    } // with failure
                } // next

                describe("#previous") {
                    context("with success") {
                        it("hits the API and returns a CursorResult") {
                            let cannedResult = CursorResult<Transaction>.sample()!
                            let currentResult = CursorResult<Transaction>.sample()!
                            api.add(result: Result<CursorResult<Transaction>, ResourceError>.success(cannedResult))

                            var tranxResult: CursorResult<Transaction>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).previous() { (result) in
                                switch result {
                                case .success(let result):
                                    tranxResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(tranxResult).toEventuallyNot(beNil())
                            expect(error).toEventually(beNil())
                        }
                    } // with success

                    context("with failure") {
                        it("hits the API and returns an error") {
                            let cannedError = ResourceError.noData
                            let currentResult = CursorResult<Transaction>.sample()!
                            api.add(result: Result<CursorResult<Transaction>, ResourceError>.failure(cannedError))

                            var tranxResult: CursorResult<Transaction>?
                            var error: UpvestError?
                            upvest.wallets().cursor(currentResult).previous() { (result) in
                                switch result {
                                case .success(let result):
                                    tranxResult = result
                                case .failure(let err):
                                    error = err
                                }
                            }

                            expect(tranxResult).toEventually(beNil())
                            expect(error).toEventuallyNot(beNil())
                            expect(error).toEventually(matchError(UpvestError.self))
                        }
                    } // with failure
                } // previous
            } // cursorTranx
        } // with auth
    } // spec

} // class
