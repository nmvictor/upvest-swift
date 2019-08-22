//
//  LocalStorageKeys.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

/// Type-safe local storage used by Upvest; these static instances encapsulate
/// the key used to store some data in local storage, along with encoding the
/// expected type information that should be returned.
enum LocalStorageKeys {
    /// The current Credential
    static let currentAuth = LocalObject<UpvestOAuth>("UPVEST_CURRENT_AUTH")

}
