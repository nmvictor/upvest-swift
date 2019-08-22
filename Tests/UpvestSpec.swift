//
//  UpvestSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 15/08/2019.
//  Copyright © 2019 Moin' Victor. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import Upvest

class UpvestSpec: QuickSpec {

    override func spec() {
        var api: StubUpvestAPI!
        var upvest: Upvest!

        beforeEach {

            api = StubUpvestAPI()
            let config = UpvestConfiguration.sample()
            Upvest.configure(configuration: config)
            upvest = StubUpvestWithMockStorage(configuration: config)
            upvest.api = api
        }

        describe("SDK_VERSION") {
            it("finds the correct bundle and returns the version number") {
                expect(Upvest.SDK_VERSION).to(match("\\d+\\.\\d+\\.\\d+"))
            }
        }

        context("without auth") {
            beforeEach {
                upvest.authManager.currentAuth = nil
            }

            describe("#getUserRepositories") {
                it("returns an error without hitting the API") {
                    var msgsResult = [Repository]()
                    var errorResult: Error?
                    upvest.getUserRepositories { result in
                        switch result {
                        case .success(let result):
                            msgsResult = result
                        case .failure(let error):
                            errorResult = error
                        }
                    }
                    expect(msgsResult.isEmpty).toEventually(beTruthy())
                    expect(errorResult).toEventually(matchError(UpvestError.noCredentials))
                }
            } // getUserRepositories

        } // without auth

        context("with auth") {
            beforeEach {
                let storedCredential = UpvestOAuth.sample()
                upvest.authManager.currentAuth = storedCredential
            }
            describe("#getUserRepositories") {
                context("with success") {
                    it("hits the API and returns [Repository] array") {
                        // add success result for get repos
                        var repos = [Repository]()
                        if let item = self.stubbedRepo() {
                            repos.append(item)
                        }
                        api.add(result: Result<[Repository], ResourceError>.success(repos))

                        var msgsResult = [Repository]()
                        var errorResult: Error?
                        upvest.getUserRepositories { result in
                            switch result {
                            case .success(let result):
                                 msgsResult = result
                            case .failure(let error):
                                 errorResult = error
                            }
                        }
                        expect(msgsResult.count).toEventually(equal(1))
                        expect(errorResult).toEventually(beNil())
                    }
                } // with success

                context("with failure") {
                    it("hits the API and returns an error") {
                        // add error result for get repos
                        let cannedError: ResourceError = .noData
                        api.add(result: Result<[Repository], ResourceError>.failure(cannedError))
                        var msgsResult = [Repository]()
                        var errorResult: Error?
                        upvest.getUserRepositories { result in
                            switch result {
                            case .success(let result):
                                msgsResult = result
                            case .failure(let error):
                                errorResult = error
                            }
                        }
                        expect(msgsResult.isEmpty).toEventually(beTruthy())
                        expect(errorResult).toEventually(matchError(UpvestError.other("no data")))
                    }
                } // with failure
            } // getUserRepositories

        } // with auth
    } // spec

    func stubbedRepo() -> Repository? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Repository", ofType: "json") else {
            fatalError("Repository.json not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(Repository.self, from: jsonData! as Data)
    }
} // class


extension UpvestConfiguration {

    class func sample() -> UpvestConfiguration {
        return UpvestConfiguration(apiUrl: "https://api.github.com", clientId: "b11sz5z2RfQi2AYJ6wSDE", clientSecret: "29046103482436420", scope: "read write echo wallet transaction", apiSettings: APISettings(apiKey: "key", apiSecret: "secret", passphrase: "passphrase"))
    }
}
