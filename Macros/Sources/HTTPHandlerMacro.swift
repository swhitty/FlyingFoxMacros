//
//  HTTPHandlerMacro.swift
//  FlyingFoxMacros
//
//  Created by Simon Whitty on 26/10/2023.
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
import Foundation

@attached(peer)
public macro HTTPRoute(
    _ route: StringLiteralType,
    statusCode: HTTPStatusCode = .ok,
    headers: [HTTPHeader: String] = [:]
) = #externalMacro(module: "Plugins", type: "HTTPRouteMacro")

@attached(peer)
public macro JSONRoute(
    _ route: StringLiteralType,
    statusCode: HTTPStatusCode = .ok,
    headers: [HTTPHeader: String] = [.contentType: "application/json"],
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder()
) = #externalMacro(module: "Plugins", type: "JSONRouteMacro")

@attached(member, names: named(performAction), named(Action), named(handleRequest))
@attached(extension, conformances: HTTPHandler, Sendable)
public macro HTTPHandler() = #externalMacro(module: "Plugins", type: "HTTPHandlerMacro")
