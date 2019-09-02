# Upvest Swift SDK

Swift library for the [Upvest API](https://doc.upvest.co/docs)
## Requirements 
- iOS 10.0+ / macOS 10.12+
- Xcode 10.2+
- Swift 5+
## Installation
### Cocoapods
[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Upvest into your Xcode project using CocoaPods, specify it in your Podfile:
```
pod 'Upvest'
```
### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Upvest into your Xcode project using Carthage, specify it in your Cartfile:
```
github "upvestco/Upvest" "1.0.0"
```
### Swift Package Manager
The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but Upvest does support its use on supported platforms.

Once you have your Swift package set up, adding `Upvest` as a dependency is as easy as adding it to the dependencies value of your `Package.swift`.

#### Swift 4

```
dependencies: [
.package(url: "https://github.com/upvestco/Upvest.git", from: "1.0.0")
]
```
Then to your Target definition in `Package.swift   `
```
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["Upvest"],
        ...
```

## Usage
### Configuring
Prior to using Upvest SDK, you MUST configure it by adding the following to your Applications init, typically in `AppDelegate.swift`
```swift
 let config = UpvestConfiguration(apiUrl: "<REPLACE THIS>", clientId: "<REPLACE THIS>", clientSecret: "<REPLACE THIS>", scope: "read write echo wallet transaction", apiSettings: APISettings(apiKey: "<REPLACE THIS>", apiSecret: "<REPLACE THIS>", passphrase: "<REPLACE THIS>"))
 Upvest.configure(configuration: config)
 
 ```
 ### Creating New User
 ```swift
 Upvest.shared.tenancy().createUser(username: "John") { (result) in
     switch result {
     case .success(let newUser):
        // handle new user
     case .failure(let err):
        //handle error
     }
  }
 ```
 ### Deleting User
 ```swift
 Upvest.shared.tenancy().deleteUser(username: "John") { (result) in
     switch result {
     case .success:
        // handle success
     case .failure(let err):
        // handle error
     }
 }
 ```
 ### Listing Users
 ```swift
  var currentResult: CursorResult<User>?
  Upvest.shared.tenancy().getUsers() { (result) in
     switch result {
     case .success(let result):
        currentResult = result
     case .failure(let err):
        // handle error
     }
 }
 ```
 You can also iterate the users result by calling `next()` or `previous()` on the cursor result
 ```swift
 Upvest.shared.tenancy().cursor(currentResult).next() { (result) in
     switch result {
     case .success(let nextResult):
        // handle next result
     case .failure(let err):
        // handle error
     }
 }
 ```
 ### Authenticating
 Some APIs require authentication with `OAuth2 `prior to being used. To authenticate your users, add the following code typically in your application login screen
 ```swift
 Upvest.shared.clientele().authenticate(username: "user", password: "pass", callback: { (result) in
     switch result {
     case .success(let auth):
        // handle auth success
     case .failure(let err):
        // handle auth error
     }
 })
 ```
 ### Listing Wallets
 ```swift
 var currentResult: CursorResult<Wallet>?
 Upvest.shared.wallets().list() { (result) in
     switch result {
     case .success(let result):
        currentResult = result
     case .failure(let err):
        // handle error
     }
 }
 ```
 You can also iterate the wallets result by calling `next()` or `previous()` on the cursor result
 ```swift
 Upvest.shared.wallets().cursor(currentResult).next() { (result) in
     switch result {
     case .success(let nextResult):
        // handle next result
     case .failure(let err):
        // handle error
     }
 }
 ```
 ### Listing Assets
 ```swift
 var currentResult: CursorResult<Asset>?
 Upvest.shared.assets().list() { (result) in
     switch result {
     case .success(let result):
        currentResult = result
     case .failure(let err):
        // handle error
     }
 }
 ```
 You can also iterate the wallets result by calling `next()` or `previous()` on the cursor result
 ```swift
 Upvest.shared.assets().cursor(currentResult).previous() { (result) in
     switch result {
     case .success(let prevResult):
        // handle prev result
     case .failure(let err):
        // handle error
     }
 }
 ```
 ### New Transaction
 ```swift
 Upvest.shared.wallets().createTransaction(walletId, assetId:, quantity, fee, password) { (result) in
     switch result {
     case .success(let newTranx):
        // handle success
     case .failure(let err):
        // handle error
     }
 }
 ```
## Contributing
### Setting up Dev Tools
1. Follow [intructions here](https://github.com/Carthage/Carthage#installing-carthage) to install carthage.
    Run the following command to install Test dependencies
```sh
$ carthage update --platform iOS
$ carthage update
```
2. Call the following script to setup necessary packages to help with Testing and Linting the code.
```sh
$ ./bin/setup
```
### Linting
With everything set up, simply run `bin/lint` to lint your code.
You can configure linting options by editiing `.swiftlint.yml`file in the project source.
### Testing
-With everything set up, simply run `bin/test` to run tests.
You can run tests from within XCode.
