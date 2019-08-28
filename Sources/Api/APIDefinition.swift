//
//  APIDefinition.swift
//  Upvest
//
//  Created by Moin' Victor on 16/08/2019.
//  Copyright © 2019 Upvest. All rights reserved.
//

import Foundation
/// A data structure to hold the `HTTPResource` defintions for the Upvest API.
///
/// A caseless enum is used in order to provide a namespace without allowing the
/// possibility of accidentally instantiating an instance of this Type.
enum APIDefinition {

    /// A resource for auhenticating with Upvest.
    ///
    /// - Parameters:
    ///   - clientId: The client id
    ///   - clientSecret: The client secret
    ///   - scope: The scope
    ///   - username: Username
    ///   - password: Password
    /// - Returns: The HttpResource
    static func authenticate(clientId: String, clientSecret: String, scope: String, username: String, password: String) -> HTTPResource<UpvestOAuth> {
        return jsonResource(
            path: "/clientele/oauth2/token",
            method: .POST,
            requestParameters: [
                "grant_type": "password",
                "client_id": clientId,
                "client_secret": clientSecret,
                "scope": scope,
                "username": username,
                "password": password
            ] as JSONDictionary,
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            parse: fromJSONDictionary
        )
    }

    /// A resource for refreshing the access token with Upvest. This is used to renew
    /// authentication tokens.
    ///
    /// - parameters:
    ///   - refreshToken: Refresh token to send to oauth2 
    /// - Returns: The HttpResource
    static func refreshAccessToken(refreshToken: String) -> HTTPResource<UpvestOAuth> {
        return jsonResource(
            path: "/clientele/oauth2/token",
            method: .POST,
            requestParameters: ["grant_type": "refresh_token", "refresh_token": refreshToken] as JSONDictionary,
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            parse: fromJSONDictionary
        )
    }

    /// A resource to echo a string from Upvest OAuth.
    ///
    /// - parameters:
    ///   - echo: The string to echo
    /// - Returns: The HttpResource
    static func getEchoOAuth2(echo: String) -> HTTPResource<Echo> {
        return jsonResource(
            path: "/clientele/echo-oauth2",
            method: .GET,
            requestParameters: ["echo": echo] as JSONDictionary,
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            parse: fromJSONDictionary
        )
    }

    /// A resource to echo a string from Upvest OAuth.
    ///
    /// - parameters:
    ///   - echo: The string to echo
    /// - Returns: The HttpResource
    static func postEchoOAuth2(echo: String) -> HTTPResource<Echo> {
        return jsonResource(
            path: "/clientele/echo-oauth2",
            method: .POST,
            requestParameters: ["echo": echo] as JSONDictionary,
            parse: fromJSONDictionary
        )
    }

    /// A resource to echo a string from Upvest with Signed API Key.
    ///
    /// - parameters:
    ///   - echo: The string to echo
    /// - Returns: The HttpResource
    static func getEchoSigned(echo: String) -> HTTPResource<Echo> {
        let payload = ["echo": echo] as JSONDictionary
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.GET.rawValue, path: "/clientele/echo-signed", payload: payload)
        return jsonResource(
            path: "/clientele/echo-signed",
            method: .GET,
            requestParameters: payload,
            headers: signedHeaders.merged(with: ["Content-Type": "application/x-www-form-urlencoded"]),
            parse: fromJSONDictionary
        )
    }

    /// A resource to echo a string from Upvest with Signed API Key.
    ///
    /// - parameters:
    ///   - echo: The string to echo
    /// - Returns: The HttpResource
    static func postEchoSigned(echo: String) -> HTTPResource<Echo> {
        let path = "/clientele/echo-signed"
        let payload = ["echo": echo] as JSONDictionary
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.POST.rawValue, path: path, payload: payload)
        return jsonResource(
            path: path,
            method: .POST,
            requestParameters: payload,
            headers: signedHeaders,
            parse: fromJSONDictionary
        )
    }

    /// A resource for retrieving cursor result
    ///
    /// - Parameters:
    ///   - url: The cursor url
    ///   - params: Optional params
    /// - Returns: The HttpResource
    static func getCursorResult<T: Codable>(url: String, params: JSONDictionary = JSONDictionary()) -> HTTPResource<CursorResult<T>> {
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.GET.rawValue, path: url, payload: params)
        return jsonResource(
            path: url,
            method: .GET,
            requestParameters: params,
            headers: signedHeaders.merged(with: ["Content-Type": "application/x-www-form-urlencoded"]),
            parse: fromJSONDictionary
        )
    }

    /// A resource for creating a new user
    ///
    /// - Parameters:
    ///   - username: The username for the user
    /// - Returns: The HttpResource
    static func createUser(username: String) -> HTTPResource<User> {
        let path = "/users"
        let payload = ["username": username] as JSONDictionary
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.POST.rawValue, path: path, payload: payload)
        return jsonResource(
            path: path,
            method: .POST,
            requestParameters: payload,
            headers: signedHeaders,
            parse: fromJSONDictionary
        )
    }

    /// A resource for deleting an existing user
    ///
    /// - Parameters:
    ///   - username: The username for the user
    /// - Returns: The HttpResource
    static func deleteUser(username: String) -> HTTPResource<Void> {
        let path = "/users/\(username)"
        let payload = JSONDictionary()
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.DELETE.rawValue, path: path, payload: payload)
        return jsonResource(
            path: path,
            method: .DELETE,
            requestParameters: payload,
            headers: signedHeaders,
            parse: noResult
        )
    }

    /// A resource for updating password for an existing user
    ///
    /// - Parameters:
    ///   - username: The username for the user
    ///   - oldPassword: The old password
    ///   - newPassword: The new password
    /// - Returns: The HttpResource
    static func updateUserPassword(username: String, oldPassword: String, newPassword: String) -> HTTPResource<User> {
        let path = "/users/\(username)"
        let payload = ["old_password": oldPassword, "new_password": newPassword] as JSONDictionary
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.PATCH.rawValue, path: path, payload: payload)
        return jsonResource(
            path: path,
            method: .PATCH,
            requestParameters: payload,
            headers: signedHeaders,
            parse: fromJSONDictionary
        )
    }

    /// A resource for resetting password for an existing user
    ///
    /// - Parameters:
    ///   - username: The username for the user
    ///   - userId: The user id
    ///   - seed: The seed configuration, from the decrypted recovery kit.
    ///   - seedHash: The hash of the seed.
    ///   - newPassword: The new password for the user
    /// - Returns: The HttpResource
    static func resetUserPassword(username: String, userId: String, seed: String, seedHash: String, newPassword: String) -> HTTPResource<BasicResult> {
        let path = "/users/\(username)"
        let payload = ["seed": seed, "seedhash": seedHash, "user_id": userId, "password": newPassword] as JSONDictionary
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.POST.rawValue, path: path, payload: payload)
        return jsonResource(
            path: path,
            method: .PATCH,
            requestParameters: payload,
            headers: signedHeaders,
            parse: fromJSONDictionary
        )
    }

    /// A resource to retrieve Asset Information
    ///
    /// - parameters:
    ///   - assetId: Unique asset ID.
    /// - Returns: The HttpResource
    static func getAssetInfomation(assetId: String) -> HTTPResource<Asset> {
        let path = "/assets/\(assetId)"
        let payload = JSONDictionary()
        let signedHeaders = signedAuthHeaders(method: HTTPMethod.GET.rawValue, path: path, payload: payload)
        return jsonResource(
            path: path,
            method: .GET,
            requestParameters: payload,
            headers: signedHeaders.merged(with: ["Content-Type": "application/x-www-form-urlencoded"]),
            parse: fromJSONDictionary
        )
    }

    /// Auth Headers HMAC signed
    ///
    /// - Parameters:
    ///   - path: Request Path
    ///   - method: Http Method
    ///   - payload: The payload
    /// - Returns: Signed Headers
    static func signedAuthHeaders(method: String, path: String, payload: JSONDictionary) -> [String: String] {
        let timestamp = Date.timeIntervalBetween1970AndReferenceDate
        let body = payload.asData?.toString() ?? "{}"
        let message = "\(timestamp)\(method)\(path)\(body)"
        let signature = message.hmac(algorithm: .SHA512, key: Upvest.apiSettings.apiSecret)
        return [
            "X-UP-API-Key": Upvest.apiSettings.apiKey,
            "X-UP-API-Passphrase": Upvest.apiSettings.passphrase,
            "X-UP-API-Timestamp": "\(timestamp)",
            "X-UP-API-Signature": signature,
            "X-UP-API-Signed-Path": path
        ]
    }

    /// A generic utility function for creating an `HTTPResource` that expects to
    /// send and receive JSON.
    ///
    /// - parameters:
    ///   - path: the path for this resource, e.g. "/devices"
    ///   - method: the HTTP method for this resource, e.g. .DELETE
    ///   - requestParameters: the JSON object to send with this request
    ///   - headers: an optional list of headers for the resource. `Content-Type`
    ///     and `Accept` headers will automatically be added in.
    ///   - parse: a closure that dictates how to map the received JSON (not Data)
    ///     into an instance of `A`.
    private static func jsonResource<A>(path: String,
                                        method: HTTPMethod,
                                        requestParameters: JSONDictionary = [:],
                                        headers: [String: String] = [:],
                                        parse: @escaping (JSONDictionary) -> A?) -> HTTPResource<A> {
        let jsonBody = requestParameters.asData

        return commonJsonResource(path: path, method: method, jsonBody: jsonBody, headers: headers, parse: parse)
    }

    /// A generic utility function for creating an `HTTPResource` that expects to
    /// send and receive JSON.
    ///
    /// - parameters:
    ///   - path: the path for this resource, e.g. "/devices"
    ///   - method: the HTTP method for this resource, e.g. .DELETE
    ///   - requestParameters: the JSON object to send with this request
    ///   - headers: an optional list of headers for the resource. `Content-Type`
    ///     and `Accept` headers will automatically be added in.
    ///   - parse: a closure that dictates how to map the received JSON (not Data)
    ///     into an instance of `[A]`.
    private static func jsonResources<A>(path: String,
                                         method: HTTPMethod,
                                         requestParameters: JSONDictionary = [:],
                                         headers: [String: String] = [:],
                                         parse: @escaping (JSONArray) -> [A]) -> HTTPResource<[A]> {
        let jsonBody = requestParameters.asData

        return commonJsonResources(path: path, method: method, jsonBody: jsonBody, headers: headers, parse: parse)
    }

    /// A generic utility function for creating an `HTTPResource` that expects to
    /// send and receive JSON.
    ///
    /// - parameters:
    ///   - path: the path for this resource, e.g. "/devices"
    ///   - method: the HTTP method for this resource, e.g. .DELETE
    ///   - requestParameters: the JSON array to send with this request
    ///   - headers: an optional list of headers for the resource. `Content-Type`
    ///     and `Accept` headers will automatically be added in.
    ///   - parse: a closure that dictates how to map the received JSON (not Data)
    ///     into an instance of `A`.
    private static func jsonResource<A>(path: String,
                                        method: HTTPMethod,
                                        requestParameters: JSONArray = [],
                                        headers: [String: String] = [:],
                                        parse: @escaping (JSONDictionary) -> A?) -> HTTPResource<A> {
        let jsonBody = requestParameters.asData
        return commonJsonResource(path: path, method: method, jsonBody: jsonBody, headers: headers, parse: parse)
    }

    /// A generic helper for creating an `HTTPResource` that expects to send and
    /// receive JSON.
    ///
    /// - parameters:
    ///   - path: the path for this resource, e.g. "/devices"
    ///   - method: the HTTP method for this resource, e.g. .DELETE
    ///   - jsonBody: JSON, encoded as Data
    ///   - headers: an optional list of headers for the resource. `Content-Type`
    ///     and `Accept` headers will automatically be added in.
    ///   - parse: a closure that dictates how to map the received JSON (not Data)
    ///     into an instance of `A`.
    private static func commonJsonResource<A>(path: String,
                                              method: HTTPMethod,
                                              jsonBody: Data?,
                                              headers: [String: String] = [:],
                                              parse: @escaping (JSONDictionary) -> A?) -> HTTPResource<A> {

        // Creates a function that parses `Data` into a `JSONDictionary`, and then
        // passes that dictionary on to the custom `parse` function to create an
        // instance of our `A` type
        let parseWrapper: (Data) -> A? = { data in
            guard let dict = data.toJSONDictionary() else { return nil }
            return parse(dict)
        }

        let headers = headers.merging(["Content-Type": "application/json", "Accept": "application/json"]) { (current, _) in current }

        return HTTPResource(path: path, method: method, requestBody: jsonBody, headers: headers, parse: parseWrapper)
    }

    /// A generic helper for creating an `HTTPResource` that expects to send and
    /// receive JSON.
    ///
    /// - parameters:
    ///   - path: the path for this resource, e.g. "/devices"
    ///   - method: the HTTP method for this resource, e.g. .DELETE
    ///   - jsonBody: JSON, encoded as Data
    ///   - headers: an optional list of headers for the resource. `Content-Type`
    ///     and `Accept` headers will automatically be added in.
    ///   - parse: a closure that dictates how to map the received JSON (not Data)
    ///     into an instance of `[A]`.
    private static func commonJsonResources<A>(path: String,
                                               method: HTTPMethod,
                                               jsonBody: Data?,
                                               headers: [String: String] = [:],
                                               parse: @escaping (JSONArray) -> [A]) -> HTTPResource<[A]> {
        // Creates a function that parses `Data` into a `JSONArray`, and then
        // passes that dictionary on to the custom `parse` function to create an
        // instance of our `[A]` type
        let parseWrapper: (Data) -> [A]? = { data in
            guard let array = data.toJSONArray() else { return nil }
            return parse(array)
        }

        let headers = headers.merging(["Content-Type": "application/json", "Accept": "application/json"]) { (current, _) in current }

        return HTTPResource(path: path, method: method, requestBody: jsonBody, headers: headers, parse: parseWrapper)
    }

    /// A helper function for when there is no expected response data.
    private static func noResult(data: Data) {
        return
    }

    /// A helper function for when there is no expected response JSON.
    private static func noResult(json: JSONDictionary) {
        return
    }

    /// A convenience initializer for decoding a JSONArray into their Array Types.
    ///
    /// - parameters:
    ///   - jsonArray: the JSON Array to encode into data
    private static func fromJSONArray<T: Codable>(jsonArray: JSONArray) -> [T] {
        var result: [T] = [T]()
        let decoder = JSONDecoder()
        for json in jsonArray {
            if let data =  json.asData, let objectT = try? decoder.decode(T.self, from: data) {
                result.append(objectT)
            }
        }
        return result
    }

    /// A convenience initializer for decoding a JSONDictionary into their Object Type.
    ///
    /// - parameters:
    ///   - jsonDict: the JSON Dictionary to encode into data
    private static func fromJSONDictionary<T: Codable>(jsonDict: JSONDictionary) -> T? {
        var result: T?
        let decoder = JSONDecoder()
        if let data =  jsonDict.asData{
           result = try? decoder.decode(T.self, from: data)
        }
        return result
    }
}
