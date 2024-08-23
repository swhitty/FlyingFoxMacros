import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroPlugins: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        HTTPRouteMacro.self,
        JSONRouteMacro.self,
        HTTPHandlerMacro.self
    ]
}
