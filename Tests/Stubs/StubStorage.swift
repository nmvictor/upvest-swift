//
//  StubStorage.swift
//  UpvestTests
//
//  Created by Moin' Victor on 23/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

@testable import Upvest

class StubStorage: LocalStorageType {
  private var memoryStore: [String: Any] = [:]

  init(_ initialContents: [String: Any]? = nil) {
    self.memoryStore = initialContents ?? [:]
  }

  func get<T>(_ item: LocalValue<T>) -> T? {
    return memoryStore[item.key] as? T
  }

  func set<T>(_ value: T?, for item: LocalValue<T>) -> Bool {
    memoryStore[item.key] = value
    return true
  }
}
