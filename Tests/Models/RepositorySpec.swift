//
//  RepositorySpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 15/08/2019.
//  Copyright © 2019 Moin' Victor. All rights reserved.
//

import Foundation
@testable import Upvest
import Nimble
import Quick

class RepositorySpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            let decoder = JSONDecoder()
            context("from valid JSON string") {
                it("returns a Repository object") {
                    let actual = self.stubbedRepo()
                    expect(actual?.id).to(equal(54361116))
                    expect(actual?.owner.login).to(equal("nmvictor"))
                    expect(actual?.url).to(equal("https://api.github.com/repos/nmvictor/UberKit"))
                    expect(actual?.isPrivate).to(equal(false))
                }
            }

            context("from invalid JSON string") {
                it("returns nil") {
                    let actual = try? decoder.decode(Repository.self, from: "{}".data(using: .utf8)!)
                    expect(actual).to(beNil())
                }
            }
        }
    }

    func stubbedRepo() -> Repository? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Repository", ofType: "json") else {
            fatalError("Repository.json not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(Repository.self, from: jsonData! as Data)
    }
}
