//
//  BaseOperation.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation

struct QueueConstant {
    static let NONE = ""
    static let MAX_RETRY = 3
    static let MAX_SEC: UInt32 = 15
}

/// Base Operation, implements OAuth in `validateOAuth()`.
// To disable OAuth, override `validateOAuth` to return `nil`
internal class BaseOperation<A>: BaseQueueOperation {
    internal var authManager: AuthManager
    fileprivate let api: UpvestAPIType
    fileprivate let MAX_SEC = 15

    let clientId: String
    /// Initialize this object
    ///
    /// - Parameters:
    ///   - authManager: an object to store credentials, keeping track of the current Credential..
    ///   - api: an object that allows talking to the Upvest API
    ///   - clientId: Client Id
    init(authManager: AuthManager, api: UpvestAPIType, clientId: String) {
        self.api = api
        self.authManager = authManager
        self.clientId = clientId
        super.init()
    }

    /// Validate that credentials aren't nil
    /// - returns:
    ///     - UpvestError: .noCredential if Upvest.shared.currentAuth is nil
    func validateOAuth() -> UpvestError? {
        if self.authManager.currentAuth == nil {
            return .noCredentials
        }
        return nil
    }

    /// If the auth token expires (error 401), this method is called before retrying to execute the failing request.
    /// It requests a new auth token, and if the call is successful, store it locally in the keychain.
    /// - parameters:
    ///   - completion: a handler for receiving the result of updating the auth token
    fileprivate func refreshAccessToken(completion: @escaping UpvestCompletion<UpvestOAuth>) {
        guard let credential = authManager.currentAuth else {
            // Should never be the case as we check credential for every request except reg_device
            completion(Result<UpvestOAuth, UpvestError>.failure(.noCredentials))
            return
        }
        let resource = APIDefinition.refreshAccessToken(refreshToken: credential.refreshToken)

        self.api.request(authToken: credential.accessToken, resource: resource) {[weak self] apiResult in
            if case .success(let credential) = apiResult {
                self?.authManager.currentAuth = credential
            }
            switch apiResult {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.other(error.localizedDescription)))
            }
        }
    }

    /// Method called to execute a new http request. The request might be first added to a queue. This persisted queue
    /// will be reexecuted later on, if for instance a request is failing, even after several attempts.
    /// Between each request attempt, there is a delay of several seconds (random(15s))
    /// - parameters:
    ///   - retry: Number of retry if the request is failing. By default, if no value is provided, the retry == 2
    ///   - resource: The resource to request
    ///   - completion: Completion block executed after the request execution.
    internal func execute<A>(retry: Int = QueueConstant.MAX_RETRY,
                             resource: @escaping () -> HTTPResource<A>,
                             completion: @escaping UpvestCompletion<A>) {
        if let error = validateOAuth() {
            completion(.failure(error))
            self.finish()
            return
        }
        let retry = (retry > QueueConstant.MAX_RETRY) ? QueueConstant.MAX_RETRY : retry
        // if the auth_token is nil, 'Authorization' is not injected in the header (see class AuthTokenBehavior)
        let authToken = self.authManager.currentAuth?.accessToken
        self.api.request(authToken: authToken, resource: resource()) {[weak self] initialResult in
            // Check for Token expiration error. If so, this piece of code get a new auth_token and retry the request.
            guard let _self = self else { return }
            switch initialResult {
            case .failure(.unauthorized):
                _self.refreshAccessToken(completion: { updateResult in
                    switch updateResult {
                    case .success:
                        _self.execute(retry: retry, resource: resource, completion: completion)
                    case .failure(let error):
                        completion(Result<A, UpvestError>.failure(error))
                        _self.finish()
                    }
                })
            case .failure(.unreachable):
                guard retry == 0 else {
                    // When run in a unit Test, DispatchQueue.asynAfter... throws an exception.
                    if Upvest.isRunningThroughUnitTest {
                        self?.execute(retry: retry - 1, resource: resource, completion: completion)
                    } else {
                    // lets attemot a retry
                        let randomDelay = Int(arc4random_uniform(QueueConstant.MAX_SEC))
                        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(randomDelay)) {
                            self?.execute(retry: retry - 1, resource: resource, completion: completion)
                        }
                    }
                    return
                }
                switch initialResult {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(.other(error.localizedDescription)))
                }
                _self.finish()
            default:
                switch initialResult {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(.other(error.localizedDescription)))
                }
                _self.finish()
            }
        }
    }
}
