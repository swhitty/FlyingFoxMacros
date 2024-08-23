//
//  HTTPRouteMacro.swift
//  FlyingFox
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

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct HTTPRouteMacro: PeerMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {

        // Only func can be a route
        guard let funcSyntax = declaration.as(FunctionDeclSyntax.self) else {
            throw CustomError.message("@HTTPRoute can only be attacehd to functions")
        }

        let funcDecl = FunctionDecl.make(from: funcSyntax)
        let routeAtt = funcDecl.attribute(name: "HTTPRoute")!

        guard funcDecl.returnType.isVoid || funcDecl.returnType.isHTTPResponse else {
            throw CustomError.message(
                "@HTTPRoute requires an function that returns HTTPResponse"
            )
        }

        guard funcDecl.parameters.isEmpty ||
                (funcDecl.parameters[0].type.isHTTPRequest && funcDecl.parameters.count == 1) else {
            throw CustomError.message(
                "@HTTPRoute requires an function with argument `HTTPRequest`"
            )
        }

        if routeAtt.expression(name: "encoder") != nil &&
                (funcDecl.returnType.isHTTPResponse || funcDecl.returnType.isVoid) {

        }

        if funcDecl.returnType.isHTTPResponse &&
           routeAtt.expression(name: "statusCode") != nil {
            context.diagnoseWarning(for: node, "statusCode is unused for return type HTTPResponse")
        }

        // Does nothing, used only to decorate functions with data
        return []
    }
}
