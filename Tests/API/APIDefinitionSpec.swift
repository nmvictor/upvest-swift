//
//  APIDefinitionSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 15/08/2019.
//  Copyright © 2019 Moin' Victor. All rights reserved.
//

// swiftlint:disable type_body_length function_body_length cyclomatic_complexity

import Foundation
import Nimble
import Quick

@testable import Upvest

class APIDefinitionSpec: QuickSpec {
    override func spec() {
        Upvest.apiSettings = UpvestConfiguration.sample().apiSettings

        describe("#authenticate") {
            it("creates a resource") {
                let clientId = "client-ID"
                let clientSecret = "secret"
                let scope = "read"
                let username = "user"
                let password = "pass"
                let resource = APIDefinition.authenticate(clientId: clientId, clientSecret: clientSecret, scope: scope, username: username, password: password)
                expect(resource.path).to(equal("/clientele/oauth2/token"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "grant_type": "password",
                    "client_id": clientId,
                    "client_secret": clientSecret,
                    "scope": scope,
                    "username": username,
                    "password": password
                    ] as JSONDictionary).to(equal(true))
                expect(resource.headers.values.contains("application/x-www-form-urlencoded")).to(beTrue())
                expect(resource.method.rawValue).to(equal("POST"))
            }
        }

        describe("#refreshAccessToken") {
            it("creates a resource") {
                let refreshToken = "refresh"
                let resource = APIDefinition.refreshAccessToken(refreshToken: refreshToken)
                expect(resource.path).to(equal("/clientele/oauth2/token"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "grant_type": "refresh_token",
                    "refresh_token": refreshToken
                    ] as JSONDictionary).to(equal(true))
                expect(resource.headers.values.contains("application/x-www-form-urlencoded")).to(beTrue())
                expect(resource.method.rawValue).to(equal("POST"))
            }
        }

        describe("#getEchoOAuth2") {
            it("creates a resource") {
                let echo = "echo"
                let resource = APIDefinition.getEchoOAuth2(echo: echo)
                expect(resource.path).to(equal("/clientele/echo-oauth2"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "echo": echo
                    ] as JSONDictionary).to(equal(true))
                expect(resource.headers.values.contains("application/x-www-form-urlencoded")).to(beTrue())
                expect(resource.method.rawValue).to(equal("GET"))
            }
        }

        describe("#postEchoOAuth2") {
            it("creates a resource") {
                let echo = "echo"
                let resource = APIDefinition.postEchoOAuth2(echo: echo)
                expect(resource.path).to(equal("/clientele/echo-oauth2"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "echo": echo
                    ] as JSONDictionary).to(equal(true))
                expect(resource.method.rawValue).to(equal("POST"))
            }
        }

        describe("#getEchoSigned") {
            it("creates a resource") {
                let echo = "echo"
                let resource = APIDefinition.getEchoSigned(echo: echo)
                expect(resource.path).to(equal("/clientele/echo-signed"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "echo": echo
                    ] as JSONDictionary).to(equal(true))
                expect(resource.headers.values.contains("application/x-www-form-urlencoded")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
                expect(resource.method.rawValue).to(equal("GET"))
            }
        }

        describe("#postEchoSigned") {
            it("creates a resource") {
                let echo = "echo"
                let resource = APIDefinition.postEchoSigned(echo: echo)
                expect(resource.path).to(equal("/clientele/echo-signed"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "echo": echo
                    ] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
                expect(resource.method.rawValue).to(equal("POST"))
            }
        }

        describe("#getCursorResult") {
            it("creates a resource") {
                let resource: HTTPResource<CursorResult<User>> = APIDefinition.getCursorResult(url: "/some/url")
                expect(resource.path).to(equal("/some/url"))
                expect(resource.method.rawValue).to(equal("GET"))
                expect(resource.headers.values.contains("application/x-www-form-urlencoded")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#createUser") {
            it("creates a resource") {
                let username = "moin"
                let resource: HTTPResource = APIDefinition.createUser(username: username)
                expect(resource.path).to(equal("/users"))
                expect(resource.method.rawValue).to(equal("POST"))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#deleteUser") {
            it("creates a resource") {
                let username = "moin"
                let resource: HTTPResource = APIDefinition.deleteUser(username: username)
                expect(resource.path).to(equal("/users/\(username)"))
                expect(resource.method.rawValue).to(equal("DELETE"))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#updateUserPassword") {
            it("creates a resource") {
                let username = "moin"
                let oldPass = "old"
                let newPass = "new"
                let resource: HTTPResource = APIDefinition.updateUserPassword(username: username, oldPassword: oldPass, newPassword: newPass)
                expect(resource.path).to(equal("/users/\(username)"))
                expect(resource.method.rawValue).to(equal("PATCH"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "old_password": oldPass,
                    "new_password": newPass
                    ] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#resetUserPassword") {
            it("creates a resource") {
                let username = "moin"
                let userId = "UID"
                let seed = "seed"
                let seedHash = "hash"
                let newPass = "new"
                let resource: HTTPResource = APIDefinition.resetUserPassword(username: username, userId: userId, seed: seed, seedHash: seedHash, newPassword: newPass)
                expect(resource.path).to(equal("/users/\(username)"))
                expect(resource.method.rawValue).to(equal("PATCH"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "user_id": userId,
                    "seed": seed,
                    "seedhash": seedHash,
                    "password": newPass
                    ] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#getAssetInfomation") {
            it("creates a resource") {
                let assetId = "UID"
                let resource: HTTPResource = APIDefinition.getAssetInfomation(assetId: assetId)
                expect(resource.path).to(equal("/assets/\(assetId)"))
                expect(resource.method.rawValue).to(equal("GET"))
                expect(resource.requestBody?.asDict() ?? [:] == [:] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#createWallet") {
            it("creates a resource") {
                let assetId = "A-UID"
                let type: Wallet.`Type` = .encrypted
                let resource: HTTPResource = APIDefinition.createWallet(assetId: assetId, type: type, index: 10, password: "pass")
                expect(resource.path).to(equal("/wallets"))
                expect(resource.method.rawValue).to(equal("POST"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "asset_id": assetId as AnyObject,
                    "type": type.rawValue as AnyObject,
                    "password": "pass" as AnyObject,
                    "index": 10 as AnyObject] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#getWalletInfomation") {
            it("creates a resource") {
                let walletId = "UID"
                let resource: HTTPResource = APIDefinition.getWalletInfomation(walletId: walletId)
                expect(resource.path).to(equal("/wallets/\(walletId)"))
                expect(resource.method.rawValue).to(equal("GET"))
                expect(resource.requestBody?.asDict() ?? [:] == [:] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#createTransaction") {
            it("creates a resource") {
                let walletId = "UID"
                let assetId = "A-UID"
                let resource: HTTPResource = APIDefinition.createTransaction(walletId: walletId, assetId: assetId, quantity: "100", fee: "10", password: "pass")
                expect(resource.path).to(equal("/wallets/\(walletId)/transactions"))
                expect(resource.method.rawValue).to(equal("POST"))
                expect(resource.requestBody?.asDict() ?? [:] == [
                    "asset_id": assetId,
                    "quantity": "100",
                    "password": "pass",
                    "fee": "10"] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#getTransactionInfomation") {
            it("creates a resource") {
                let walletId = "UID"
                let tranxId = "TRANX-UID"
                let resource: HTTPResource = APIDefinition.getTransactionInfomation(walletId: walletId, tranxId: tranxId)
                 expect(resource.path).to(equal("/wallets/\(walletId)/transactions/\(tranxId)"))
                expect(resource.method.rawValue).to(equal("GET"))
                expect(resource.requestBody?.asDict() ?? [:] == [:] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }

        describe("#signWithWallet") {
            it("creates a resource") {
                let walletId = "w-id"
                let resource: HTTPResource = APIDefinition.signWithWallet(walletId: walletId, toSign: "my-hash", inputFormat: .hex, outputFormat: .base64LittleEndian, password: "pass")
                expect(resource.path).to(equal("/wallets/\(walletId)/sign"))
                expect(resource.method.rawValue).to(equal("POST"))
                expect(resource.requestBody?.asDict() ?? [:] == ["to_sign": "my-hash", "input_format": Wallet.SignInputFormat.hex.rawValue, "output_format": Wallet.SignOutputFormat.base64LittleEndian.rawValue, "password": "pass"] as JSONDictionary).to(equal(true))
                expect(resource.headers.keys.contains("X-UP-API-Key")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signed-Path")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Signature")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Timestamp")).to(beTrue())
                expect(resource.headers.keys.contains("X-UP-API-Passphrase")).to(beTrue())
            }
        }
    }
}
