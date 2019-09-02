import Foundation
import Nimble
import Quick
@testable import Upvest

class UpvestOAuthSpec: QuickSpec {
    override func spec() {
        describe(".decodeJSON") {
            context("with usable JSON dictionary") {
                it("returns a UpvestOAuth") {
                    let dictionary: JSONDictionary = [
                        "access_token": "zSMWkPGyMatY8oYVsFEv1Pr9sjMS3Q"as AnyObject,
                        "expires_in": 36000 as AnyObject,
                        "token_type": "Bearer" as AnyObject,
                        "scope": "read write echo wallet transaction" as AnyObject,
                        "refresh_token": "iYmTFUisTiNSwdwFaNQ63U1a6bOBNs" as AnyObject
                    ]
                    let auth = UpvestOAuth.fromJSON(dictionary: dictionary)
                    expect(auth?.accessToken).to(equal("zSMWkPGyMatY8oYVsFEv1Pr9sjMS3Q"))
                    expect(auth?.expiresIn).to(equal(36000))
                    expect(auth?.tokenType).to(equal("Bearer"))
                    expect(auth?.scope).to(equal("read write echo wallet transaction"))
                    expect(auth?.refreshToken).to(equal("iYmTFUisTiNSwdwFaNQ63U1a6bOBNs"))
                }

                context("with unusable JSON dictionary") {
                    it("returns nil") {
                        let dictionary: JSONDictionary = [:]
                        expect(UpvestOAuth.fromJSON(dictionary: dictionary)).to(beNil())
                    }
                }
            }
        }
    }
}

extension UpvestOAuth {
    static func fromJSON(dictionary: JSONDictionary) -> UpvestOAuth? {
        if dictionary.isEmpty {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(UpvestOAuth.self, from: dictionary.asData! as Data)
    }

    static func sample() -> UpvestOAuth {
        return UpvestOAuth(accessToken: "zSMWkPGyMatY8oYVsFEv1Pr9sjMS3Q", tokenType: "Bearer", scope: "read write echo wallet transaction", expiresIn: 1300, refreshToken: "iYmTFUisTiNSwdwFaNQ63U1a6bOBNs")
    }
}
