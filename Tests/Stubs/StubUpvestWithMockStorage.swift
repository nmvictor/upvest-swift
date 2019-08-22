
@testable import Upvest

class StubUpvestWithMockStorage: Upvest {
    override class func getStorageWith() -> LocalStorageType {
        return StubStorage()
    }
}
