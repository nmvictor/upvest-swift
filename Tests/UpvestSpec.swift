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

    } // spec
} // class


extension UpvestConfiguration {

    class func sample() -> UpvestConfiguration {
        return UpvestConfiguration(apiUrl: "https://api.github.com", clientId: "b11sz5z2RfQi2AYJ6wSDE", clientSecret: "29046103482436420", scope: "read write echo wallet transaction", apiSettings: APISettings(apiKey: "key", apiSecret: "secret", passphrase: "passphrase"))
    }
}
