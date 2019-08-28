//
//  UserSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 15/08/2019.
//  Copyright © 2019 Moin' Victor. All rights reserved.
//

import Nimble
import Quick

@testable import Upvest

class UserSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            let decoder = JSONDecoder()
            context("from valid JSON string") {
                it("returns a User object") {
                    let actual = self.stubbedUser()
                    expect(actual?.walletIds.count).to(equal(2))
                    expect(actual?.username).to(equal("Jane Doe"))
                    expect(actual?.recoverykit).to(equal("<svg height=\"125mm\" version=\"1.1\" viewBox=\"0 0 125 125\" width=\"125mm\" xmlns=\"http://www.w3.org/2000/ ..."))
                    expect(actual?.walletIds.first).to(equal("7e0af700-baed-45c2-9455-e43f88e9501a"))
                }
            }

            context("from invalid JSON string") {
                it("returns nil") {
                    let actual = try? decoder.decode(User.self, from: "{}".data(using: .utf8)!)
                    expect(actual).to(beNil())
                }
            }
        }
    }

    func stubbedUser() -> User? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "User", ofType: "json") else {
            fatalError("User.json not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(User.self, from: jsonData! as Data)
    }
}

extension User {

    class func sample() -> User? {
        let decoder = JSONDecoder()
        let actual = try? decoder.decode(User.self, from: "{\"username\":\"Jane Doe\"}".data(using: .utf8)!)
        return actual
    }
}
