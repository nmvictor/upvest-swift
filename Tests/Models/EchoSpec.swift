//
//  EchoSpec.swift
//  Upvest
//
//  Created by Moin' Victor on 22/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import Upvest

class EchoSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            context("with usable JSON dictionary") {
                it("returns a UpvestOAuth") {
                    let dictionary: JSONDictionary = [
                        "echo": "Hello World"as AnyObject
                    ]
                    expect(Echo.fromJSON(dictionary: dictionary)?.echo).to(equal("Hello World"))
                }

                context("with unusable JSON dictionary") {
                    it("returns nil") {
                        let dictionary: JSONDictionary = [:]
                        expect(Echo.fromJSON(dictionary: dictionary)).to(beNil())
                    }
                }
            }
        }
    }
}

extension Echo {

    static func fromJSON(dictionary: JSONDictionary) -> Echo? {
        if dictionary.isEmpty {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(Echo.self, from: dictionary.asData! as Data)
    }

    static func sample() -> Echo {
        return Echo(echo: "Hello World")
    }
}
