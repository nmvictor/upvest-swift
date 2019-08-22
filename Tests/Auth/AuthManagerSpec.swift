import Foundation
import Quick
import Nimble
@testable import Upvest

class AuthManagerSpec: QuickSpec {
  override func spec() {

    describe("#currentAuth=") {
      context("with credential") {
        it("stores the current credential") {
          let storage = StubStorage()
          let manager = AuthManager(storage: storage)
          let auth = UpvestOAuth(accessToken: "zSMWkPGyMatY8oYVsFEv1Pr9sjMS3Q", tokenType: "Bearer", scope: "read write echo wallet transaction", expiresIn: 1300, refreshToken: "iYmTFUisTiNSwdwFaNQ63U1a6bOBNs")

          manager.currentAuth = auth

          expect(manager.currentAuth).to(equal(auth))
        }
      }

      context("with nil") {
        it("removes the current credential") {
          let storage = StubStorage()
          let manager = AuthManager(storage: storage)

          manager.currentAuth = nil

          expect(manager.currentAuth).to(beNil())
        }
      }
    }
  }
}
