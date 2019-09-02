//
//  SignedWithWalletResultSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 02/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Upvest

class SignedWithWalletResultSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            let decoder = JSONDecoder()
            context("from valid JSON string") {
                it("returns a User object") {
                    let actual = self.stubbedTransaction()
                    expect(actual?.bigNumberFormat).to(equal("int64"))
                    expect(actual?.publicKey.x).to(equal("3"))
                    expect(actual?.publicKey.y).to(equal("4"))
                    expect(actual?.recover).to(equal("erc20_ropsten"))
                    expect(actual?.s).to(equal("S"))
                    expect(actual?.r).to(equal("R"))
                    expect(actual?.algorithm).to(equal("ECDSA"))
                    expect(actual?.curve).to(equal("c12"))
                }
            }

            context("from invalid JSON string") {
                it("returns nil") {
                    let actual = try? decoder.decode(SignedWithWalletResult.self, from: "{}".data(using: .utf8)!)
                    expect(actual).to(beNil())
                }
            }
        }
    }

    func stubbedTransaction() -> SignedWithWalletResult? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "SignedWithWalletResult", ofType: "json") else {
            fatalError("SignedWithWalletResult.json not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(SignedWithWalletResult.self, from: jsonData! as Data)
    }
}

extension SignedWithWalletResult {

    class func sample() -> SignedWithWalletResult? {
        let jsonString = "{\"big_number_format\":\"int64\",\"algorithm\":\"ECDSA\",\"curve\": \"c12\",\"recover\": \"erc20_ropsten\",\"r\": \"R\",\"s\": \"S\",\"public_key\": {\"x\": \"3\",\"y\": \"4\"}}"
        let decoder = JSONDecoder()
        let actual = try? decoder.decode(SignedWithWalletResult.self, from: jsonString.data(using: .utf8)!)
        return actual
    }
}
