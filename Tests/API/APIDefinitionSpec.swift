//
//  APIDefinitionSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 15/08/2019.
//  Copyright © 2019 Moin' Victor. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Upvest

class APIDefinitionSpec: QuickSpec {
    override func spec() {
        describe("#getUserRepositories") {
            context("with username") {
                it("creates a resource") {
                    let usrName = "test"
                    let resource = APIDefinition.getUserRepositories(username: usrName)
                    expect(resource.path).to(equal("/users/test/repos"))
                    expect(resource.method.rawValue).to(equal("GET"))
                }
            }

            context("without username") {
                it("creates a resource") {
                    let resource = APIDefinition.getUserRepositories()
                    expect(resource.path).to(equal("/user/repos"))
                    expect(resource.method.rawValue).to(equal("GET"))
                }
            }
        }

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
                    "refresh_token": refreshToken,
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
                expect(resource.headers.values.contains("application/x-www-form-urlencoded")).to(beTrue())
                expect(resource.method.rawValue).to(equal("POST"))
            }
        }
    }
}
