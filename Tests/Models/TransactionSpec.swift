//
//  TransactionSpec.swift
//  UpvestTests
//
//  Created by Moin' Victor on 02/09/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Upvest

class TransactionSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            let decoder = JSONDecoder()
            context("from valid JSON string") {
                it("returns a User object") {
                    let actual = self.stubbedTransaction()
                    expect(actual?.id).to(equal("ae110533-2e23-4f6a-9c3e-adfaa95b1440"))
                    expect(actual?.quantity).to(equal("37"))
                    expect(actual?.txHash).to(equal("0xe947bf4832ab5360aebc6e4407eb27e493c5da5ae5304aa10dbfddf123379f5b"))
                    expect(actual?.status).to(equal(Transaction.Status.confirmed))
                    expect(actual?.exponent).to(equal(12))
                    expect(actual?.sender).to(equal("0x6720d291a72b8673e774a179434c96d21eb85e71"))
                    expect(actual?.recipient).to(equal("0x342b13903CFAC27aF1133bb29F2E3Fe9Bf4b0B9B"))
                    expect(actual?.fee).to(equal("0"))
                    expect(actual?.assetId).to(equal("cfc59efb-3b21-5340-ae96-8cadb4ce31a8"))
                    expect(actual?.walletId).to(equal("3bf016a1-24d4-46e4-9800-9e3f223b9fab"))
                    expect(actual?.assetName).to(equal("Example coin"))
                }
            }

            context("from invalid JSON string") {
                it("returns nil") {
                    let actual = try? decoder.decode(Transaction.self, from: "{}".data(using: .utf8)!)
                    expect(actual).to(beNil())
                }
            }
        }
    }

    func stubbedTransaction() -> Transaction? {
        let decoder = JSONDecoder()
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Transaction", ofType: "json") else {
            fatalError("Transaction.json not found")
        }

        // 2. load into Data object
        let jsonData = NSData(contentsOfFile: pathString)
        return try? decoder.decode(Transaction.self, from: jsonData! as Data)
    }
}

extension Transaction {

    class func sample() -> Transaction? {
        let jsonString = "{\"quantity\":\"37\",\"fee\":\"0\",\"recipient\":\"0x342b13903CFAC27aF1133bb29F2E3Fe9Bf4b0B9B\",\"sender\":\"0x6720d291a72b8673e774a179434c96d21eb85e71\",\"id\":\"ae110533-2e23-4f6a-9c3e-adfaa95b1440\",\"status\":\"CONFIRMED\",\"txhash\":\"0xe947bf4832ab5360aebc6e4407eb27e493c5da5ae5304aa10dbfddf123379f5b\",\"wallet_id\":\"3bf016a1-24d4-46e4-9800-9e3f223b9fab\",\"asset_id\":\"cfc59efb-3b21-5340-ae96-8cadb4ce31a8\",\"asset_name\":\"Example coin\",\"exponent\":12}"
        let decoder = JSONDecoder()
        let actual = try? decoder.decode(Transaction.self, from: jsonString.data(using: .utf8)!)
        return actual
    }
}
