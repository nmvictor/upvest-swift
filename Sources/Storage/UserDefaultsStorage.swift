//
//  UserDefaultsStorage.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
/// A storage adapter that uses UserDefaults as a local storage mechanism.
struct UserDefaultsStorage {
    /// The defaults object to use for storage
    fileprivate let defaults: UserDefaults

    /// Initialize this object.
    /// - parameters:
    ///   - defaults: the defaults object to use for storage
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
}

extension UserDefaultsStorage: LocalStorageType {
    func get<T>(_ item: LocalValue<T>) -> T? {
        return defaults.object(forKey: item.key) as? T
    }

    func set<T>(_ value: T?, for item: LocalValue<T>) -> Bool {
        if let value = value {
            defaults.set(value, forKey: item.key)
        } else {
            defaults.removeObject(forKey: item.key)
        }
        defaults.synchronize()

        return true
    }
}
