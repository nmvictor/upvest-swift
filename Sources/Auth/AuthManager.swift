//
//  AuthManager.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

/// Handles storing auth data, keeping track of the current Auth, etc.
class AuthManager {
  /// An object for storing data in some kind of local storage.
  private let storage: LocalStorageType

  /// The currently-active Auth
  var currentAuth: UpvestOAuth? {
    get {
      return storage.get(LocalStorageKeys.currentAuth)
    }

    set {
      storage.set(newValue, for: LocalStorageKeys.currentAuth)
    }
  }

  /// Initialize this object.
  ///
  /// - parameters:
  ///   - storage: an object that allows storing data locally
  init(storage: LocalStorageType) {
    self.storage = storage
  }

}
