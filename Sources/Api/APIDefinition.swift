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

    /// A resource to echo a string from Upvest.
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

    /// A resource to echo a string from Upvest.
    ///
    /// - parameters:
    ///   - echo: The string to echo
    /// - Returns: The HttpResource
    static func postEchoOAuth2(echo: String) -> HTTPResource<Echo> {
        return jsonResource(
            path: "/clientele/echo-oauth2",
            method: .POST,
            requestParameters: ["echo": echo] as JSONDictionary,
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            parse: fromJSONDictionary
        )
    }

    /// A resource for retrieving user repositories
    ///
    /// - Parameter username: The optional username, if not provided, we get repos for current user authetnicated by token
    /// - Returns: The HttpResource
    static func getUserRepositories(username: String? = nil) -> HTTPResource<[Repository]> {
        return jsonResources(
            path: username != nil ? "/users/\(username!)/repos" : "/user/repos",
            method: .GET,
            requestParameters: JSONDictionary(),
            parse: fromJSONArray
        )
    }

    /// Auth Headers HMAC signed
    ///
    /// - Parameters:
    ///   - path: Request Path
    ///   - method: Http Method
    ///   - payload: The payload
    /// - Returns: Signed Headers
    func signedAuthHeaders(method: String, path: String, payload: JSONDictionary) -> [String: String] {
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
        decoder.keyDecodingStrategy = .convertFromSnakeCase
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
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data =  jsonDict.asData{
           result = try? decoder.decode(T.self, from: data)
        }
        return result
    }
}
