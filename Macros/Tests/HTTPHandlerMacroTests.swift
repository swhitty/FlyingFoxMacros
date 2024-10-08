//
//  HTTPHandlerMacroTests.swift
//  FlyingFoxMacros
//
//  Created by Simon Whitty on 28/10/2023.
//  Copyright © 2023 Simon Whitty. All rights reserved.
//
//  Distributed under the permissive MIT license
//  Get the latest version from here:
//
//  https://github.com/swhitty/FlyingFox
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import FlyingFox
import FlyingFoxMacros
import XCTest

final class HTTPHandlerMacroTests: XCTestCase {

    func testHandler() async throws {
        let handler = MacroHandler()

        await AsyncAssertEqual(
            try await handler.handleRequest(.make(path: "/ok")).statusCode,
            .ok
        )
        await AsyncAssertEqual(
            try await handler.handleRequest(.make(path: "/accepted")).statusCode,
            .accepted
        )
        await AsyncAssertEqual(
            try await handler.handleRequest(.make(path: "/teapot")).statusCode,
            .teapot
        )

        await AsyncAssertEqual(
            try await handler.handleRequest(.make(path: "/fish")).jsonDictionaryBody,
            ["name": "Pickles"]
        )
    }
}

@HTTPHandler
private struct MacroHandler {

    @HTTPRoute("/ok")
    func didAppear() -> HTTPResponse {
        HTTPResponse(statusCode: .ok)
    }

    @HTTPRoute("/accepted")
    func willAppear(_ val: HTTPRequest) async -> HTTPResponse {
        HTTPResponse(statusCode: .accepted)
    }

    @HTTPRoute("/teapot", statusCode: .teapot)
    func getTeapot() throws { }

    @JSONRoute("/fish")
    func getFish() -> Fish {
        Fish(name: "Pickles")
    }

    struct Fish: Encodable {
        var name: String
    }
}

private extension HTTPResponse {

    var jsonDictionaryBody: NSDictionary? {
        get async {
            guard let data = try? await bodyData,
                  let object = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return nil
            }
            return object as? NSDictionary
        }
    }
}
