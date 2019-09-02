//
//  WalletSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 29/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Upvest

class WalletSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            let decoder = JSONDecoder()
            context("from valid JSON string") {
                it("returns a User object") {
                    let actual = self.stubbedWallet()
                    expect(actual?.id).to(equal("3bf016a1-24d4-46e4-9800-9e3f223b9fab"))
                    expect(actual?.address).to(equal("0x0123456789ABCDEF"))
                    expect(actual?.status).to(equal("ACTIVE"))
                    expect(actual?.index).to(equal(0))
                    expect(actual?.protocol).to(equal("co.upvest.kinds.Erc20"))
                    expect(actual?.balances.first?.exponent).to(equal(18))
                    expect(actual?.balances.first?.amount).to(equal("10000000"))
                    expect(actual?.balances.first?.name).to(equal("Ether (Ropsten)"))
                    expect(actual?.balances.first?.symbol).to(equal("ETH"))
                    expect(actual?.balances.first?.assetId).to(equal("deaaa6bf-d944-57fa-8ec4-2dd45d1f5d3f"))
                }
            }

            context("from invalid JSON string") {
                it("returns nil") {
                    let actual = try? decoder.decode(Wallet.self, from: "{}".data(using: .utf8)!)
                    expect(actual).to(beNil())
                }
            }
        }
    }

    func stubbedWallet() -> Wallet? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Wallet", ofType: "json") else {
            fatalError("Wallet.json not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(Wallet.self, from: jsonData! as Data)
    }
}

extension Wallet {

    class func sample() -> Wallet? {
        let jsonString = "{\"id\":\"3bf016a1-24d4-46e4-9800-9e3f223b9fab\",\"balances\": [{\"amount\":\"10000000\",\"asset_id\":\"deaaa6bf-d944-57fa-8ec4-2dd45d1f5d3f\",\"name\":\"Ether (Ropsten)\",\"symbol\":\"ETH\",\"exponent\":18}],\"address\":\"0x0123456789ABCDEF\",\"protocol\":\"co.upvest.kinds.Erc20\",\"index\":0,\"status\":\"ACTIVE\"}"
        let decoder = JSONDecoder()
        let actual = try? decoder.decode(Wallet.self, from: jsonString.data(using: .utf8)!)
        return actual
    }
}
