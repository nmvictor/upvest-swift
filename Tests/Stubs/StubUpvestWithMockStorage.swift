//
//  StubUpvestWithMockStorage.swift
//  UpvestTests
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

@testable import Upvest

class StubUpvestWithMockStorage: Upvest {
    override class func getStorageWith() -> LocalStorageType {
        return StubStorage()
    }
}
