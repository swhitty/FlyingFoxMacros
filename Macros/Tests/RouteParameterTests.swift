//
//  RouteParameterTests.swift
//  FlyingFoxMacros
//
//  Created by Simon Whitty on 23/08/2024.
//  Copyright © 2024 Simon Whitty. All rights reserved.
//
//  Distributed under the permissive MIT license
//  Get the latest version from here:
//
//  https://github.com/swhitty/FlyingFoxMacros
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

final class RouteParameterTests: XCTestCase {

    func testHandler() async throws {
        let handler = MacroHandler()

        await AsyncAssertEqual(
            try await handler.handleRequest(.make(path: "/creature/pickles?kind=fish")).jsonDictionaryBody,
            ["name": "pickles", "kind": "fish"]
        )
    }
}

@HTTPHandler
private struct MacroHandler {

    @JSONRoute("GET /creature/:name?kind=:beast")
    func getCreature(kind: Creature.Kind, name: String) -> Creature {
        Creature(name: name, kind: kind)
    }

    struct Creature: Encodable {
        var name: String
        var kind: Kind

        enum Kind: String, Encodable {
            case fish
            
        }
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
