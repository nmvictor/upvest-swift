//
//  CursorResultSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
@testable import Upvest
import Nimble
import Quick

class CursorResultSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            let decoder = JSONDecoder()
            context("from valid JSON string") {
                it("returns a CursorResult object") {
                    let actual = self.stubbedUsersResult()
                    expect(actual?.results.count).to(equal(2))
                    expect(actual?.next).to(equal("https://api.playground.upvest.co/1.0/tenancy/users/?cursor=xyz"))
                    expect(actual?.previous).to(equal("https://api.playground.upvest.co/1.0/tenancy/users/?cursor=abc"))
                    expect(actual?.results.first?.username).to(equal("Jane Doe"))
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

    func stubbedUsersResult() -> CursorResult<User>? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "UsersResult", ofType: "json") else {
            fatalError("UsersResult not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(CursorResult<User>.self, from: jsonData! as Data)
    }
}

extension CursorResult {

    class func sample() -> CursorResult<T>? {
        let decoder = JSONDecoder()
        let actual = try? decoder.decode(CursorResult<T>.self, from: "{\"previous\": \"https://api.playground.upvest.co/1.0/tenancy/users/?cursor=abc\",\"next\": \"https://api.playground.upvest.co/1.0/tenancy/users/?cursor=xyz\",\"results\":[]}".data(using: .utf8)!)
        return actual
    }
}
