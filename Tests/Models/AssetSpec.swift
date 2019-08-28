//
//  AssetSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 28/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Nimble
import Quick

@testable import Upvest

class AssetSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            let decoder = JSONDecoder()
            context("from valid JSON string") {
                it("returns a User object") {
                    let actual = self.stubbedAsset()
                    expect(actual?.id).to(equal("cfc59efb-3b21-5340-ae96-8cadb4ce31a8"))
                    expect(actual?.name).to(equal("Example coin (Ropsten)"))
                    expect(actual?.symbol).to(equal("COIN"))
                    expect(actual?.exponent).to(equal(12))
                    expect(actual?.protocol).to(equal("erc20_ropsten"))
                    expect(actual?.metadata?.chainId).to(equal(3))
                    expect(actual?.metadata?.contract).to(equal("0xb95185ca02B704e46721d878EE7f566C6a2a959f"))
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

    func stubbedAsset() -> Asset? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Asset", ofType: "json") else {
            fatalError("Asset.json not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(Asset.self, from: jsonData! as Data)
    }
}

extension Asset {

    class func sample() -> Asset? {
        let jsonString = "{\"id\":\"cfc59efb-3b21-5340-ae96-8cadb4ce31a8\",\"name\":\"Example coin (Ropsten)\",\"symbol\":\"COIN\",\"exponent\":12,\"protocol\":\"erc20_ropsten\",\"metadata\":{\"chain_id\":3,\"contract\":\"0xb95185ca02B704e46721d878EE7f566C6a2a959f\"}}"
        let decoder = JSONDecoder()
        let actual = try? decoder.decode(Asset.self, from: jsonString.data(using: .utf8)!)
        return actual
    }
}
