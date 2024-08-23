[![Build](https://github.com/swhitty/FlyingFoxMacros/actions/workflows/build.yml/badge.svg)](https://github.com/swhitty/FlyingFoxMacros/actions/workflows/build.yml)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS%20|%20Linux%20|%20Windows-lightgray.svg)](https://github.com/swhitty/FlyingFoxMacros/blob/main/Package.swift)
[![Swift 6.0](https://img.shields.io/badge/swift-5.9%20–%206.0-red.svg?style=flat)](https://developer.apple.com/swift)
[![Twitter](https://img.shields.io/badge/twitter-@simonwhitty-blue.svg)](http://twitter.com/simonwhitty)

# FlyingFoxMacros

Macros for [FlyingFox](https://github.com/swhitty/FlyingFox) allowing handlers to annotate functions with routes.

# Installation

FlyingFoxMacros can be installed by using Swift Package Manager.

**Note:** FlyingFox requires Swift 5.9 on Xcode 15+. It runs on iOS 13+, tvOS 13+, watchOS 8+, macOS 10.15+ and Linux. Windows 10 support is experimental.

To install using Swift Package Manager, add this to the `dependencies:` section in your Package.swift file:

```swift
.package(url: "https://github.com/swhitty/FlyingFox.git", .upToNextMajor(from: "0.16.0")),
.package(url: "https://github.com/swhitty/FlyingFoxMacros.git", .upToNextMajor(from: "0.1.0"))
```

# Usage

Methods can be annotated with `HTTPRoute` to automatically syntesise a `HTTPHandler`.

```swift
import FlyingFox
import FlyingFoxMacros

@HTTPHandler
struct MyHandler {

  @HTTPRoute("/ping")
  func ping() { }

  @HTTPRoute("/pong")
  func getPong(_ request: HTTPRequest) -> HTTPResponse {
    HTTPResponse(statusCode: .accepted)
  }

  @JSONRoute("POST /account")
  func createAccount(body: AccountRequest) -> AccountResponse {
    AccountResponse(id: UUID(), balance: body.balance)
  }
}

let server = HTTPServer(port: 80, handler: MyHandler())
try await server.start()
```

The annotations are implemented via [SE-0389 Attached Macros](https://github.com/apple/swift-evolution/blob/main/proposals/0389-attached-macros.md).

The macro synthesises conformance to `HTTPHandler` delegating handling to the first matching route. Expanding the example above to the following:

```swift
func handleRequest(_ request: HTTPRequest) async throws -> HTTPResponse {
  if await HTTPRoute("/ping") ~= request {
    ping()
    return HTTPResponse(statusCode: .ok, headers: [:])
  }
  if await HTTPRoute("/pong") ~= request {
    return getPong(request)
  }
  if await HTTPRoute("POST /account") ~= request {
    let body = try await JSONDecoder().decode(AccountRequest.self, from: request.bodyData)
    let ret = createAccount(body: body)
    return try HTTPResponse(
      statusCode: .ok,
      headers: [.contentType: "application/json"],
      body: JSONEncoder().encode(ret)
    )
  }
  throw HTTPUnhandledError()
}
```

`@HTTPRoute` annotations can specify specific properties of the returned `HTTPResponse`:

```swift
@HTTPRoute("/refresh", statusCode: .teapot, headers: [.eTag: "t3a"])
func refresh()
```

`@JSONRoute` annotations can be added to functions that accept `Codable` types. `JSONDecoder` decodes the body that is passed to the method, the returned object is encoded to the response body using `JSONEncoder`:

```swift
@JSONRoute("POST /account")
func createAccount(body: AccountRequest) -> AccountResponse
```

The original `HTTPRequest` can be optionally passed to the method:

```swift
@JSONRoute("POST /account")
func createAccount(request: HTTPRequest, body: AccountRequest) -> AccountResponse
```

`JSONEncoder` / `JSONDecoder` instances can be passed for specific JSON coding strategies:

```swift
@JSONRoute("GET /account", encoder: JSONEncoder())
func getAccount() -> AccountResponse
```
