//
//  Upvest.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import UIKit

/// A closure used as a completion handler for interacting with the Upvest
/// object.
public typealias UpvestCompletion<A> = (Result<A, UpvestError>) -> Void

private var upvestInstance: Upvest!

/// The main entry point for usage of the Upvest API.
@objc public class Upvest: NSObject {
    
    /// The released version of the Upvest SDK
    public static let SDK_VERSION = "1.0.0"

    /// Default configuration
    public internal(set) var configuration: UpvestConfiguration {
        didSet {
            Upvest.apiSettings = self.configuration.apiSettings
        }
    }

    public internal(set) static var apiSettings: APISettings!

    /// An object that can communicate with the Upvest API.
    internal var api: UpvestAPIType {
        didSet {
            clienteleApi.api = api
            tenancyApi.api = api
            assetsApi.api = api
        }
    }

    /// An object that handles managing auth
    let authManager: AuthManager

    /// An object that handles clientele API
    private let clienteleApi: ClienteleAPI

    /// An object that handles Tenancy API
    private let tenancyApi: TenancyAPI

    /// An object that handles Assets API
    private let assetsApi: AssetsAPI

    /// An object that allows for persisting data locally
    internal var storage: LocalStorageType

    /// Queue for executing http requests
    fileprivate static var queue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1 // Serial queue operation
        return operationQueue
    }()

    /// The shared (singleton) instance of Upvest.
    @objc public internal(set) static var shared: Upvest! {
        get {
            if upvestInstance == nil {
                fatalError("You must call Upvest.configure before using Upvest.shared")
            }
            return upvestInstance
        }

        set(newValue) {
            upvestInstance = newValue
        }
    }

    /// Trick to detect wheter the application has been started for
    /// executing unit tests. 
    public static let isRunningThroughUnitTest: Bool = {
        if let testClass = NSClassFromString("XCTestCase") {
            return true
        } else {
            return false
        }
    }()

    fileprivate var auth: UpvestOAuth? {
        return self.authManager.currentAuth
    }

    /// Get Clientele API
    ///
    /// - Returns: The Clientele API
    func clientele() -> ClienteleAPI {
        return clienteleApi
    }

    /// Get Clientele API
    ///
    /// - Returns: The Tenancy API
    func tenancy() -> TenancyAPI {
            return tenancyApi
    }

    /// Get Assets API
    ///
    /// - Returns: The Assets API
    func assets() -> AssetsAPI {
        return assetsApi
    }

    ///
    /// Get the storage according the storage type choosen by the user.
    /// - returns:
    ///   - LocalStorageType
    ///
    internal class func getStorageWith() -> LocalStorageType {
        return UserDefaultsStorage()
    }

    ///
    /// Initialize this object.
    ///
    /// - parameters:
    ///   - configuration: the config object
    ///
    init(configuration: UpvestConfiguration) {
        self.configuration = configuration
        api = UpvestAPI(url: self.configuration.upvestAPIURL)
        let storageToUse = type(of: self).getStorageWith()
        self.storage = storageToUse
        self.authManager = AuthManager(storage: storageToUse)
        self.clienteleApi = ClienteleAPI(authManager: authManager, api: api, clientId: self.configuration.clientId, clientSecret: self.configuration.clientSecret, scope: self.configuration.scope)
        self.tenancyApi = TenancyAPI(authManager: authManager, api: api, clientId: self.configuration.clientId, clientSecret: self.configuration.clientSecret, scope: self.configuration.scope)
        self.assetsApi = AssetsAPI(authManager: authManager, api: api, clientId: self.configuration.clientId, clientSecret: self.configuration.clientSecret, scope: self.configuration.scope)

    }

    ///
    /// Submit a new operation (REG_DEVICE, UNREG_DEVICE ...)
    /// If the current queue isn't empty, the operation will be executed
    /// when the last operation of the queue is finished.
    ///
    internal class func submit<A>(operation: BaseOperation<A>) {
        if queue.operations.count > 0 {
            operation.addDependency(queue.operations.last!)
        }
        queue.addOperation(operation)
    }

    ///////////////////////////////////////////// OPERATIONS /////////////////////////////////////////////
}

extension Upvest {
    ///
    /// Configure the shared Upvest instance. This must be called before using any
    /// of the functionality of Upvest, like registering your device.
    ///
    /// - parameters:
    ///   - configuration: Contains all the properties to configure Upvest
    ///
    @objc public static func configure(configuration: UpvestConfiguration) {
        shared = Upvest(configuration: configuration)
    }
}

public class UpvestConfiguration: NSObject {
    /// The default URL to hit when talking to the Upvest API
    public let apiUrl: String

    /// Client Id
    public let clientId: String

    /// Client Secret
    public let clientSecret: String

    /// Scope
    public let scope: String

    public let apiSettings: APISettings

    public var upvestAPIURL: URL {
        if let url = URL(string: self.apiUrl) {
            return url
        } else {
            return URL(string: UpvestConfiguration.defaultApiUrl)!
        }
    }

    // MARK: Private Static Properties

    /// The default URL to hit when talking to the Upvest API
    private static let defaultApiUrl = "https://api.upvest.com/rest"

    public init(apiUrl: String? = nil,
                clientId: String,
                clientSecret: String,
                scope: String,
                apiSettings: APISettings) {
        self.apiUrl = apiUrl ?? UpvestConfiguration.defaultApiUrl
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.scope = scope
        self.apiSettings = apiSettings
    }
}

public class APISettings: NSObject {
    /// API Key
    public let apiKey: String

    /// API Secret
    public let apiSecret: String

    /// Pass phrase
    public let passphrase: String

    public init(apiKey: String,
                apiSecret: String,
                passphrase: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.passphrase = passphrase
    }
}
