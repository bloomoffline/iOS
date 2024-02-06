//
//  EnvironmentUtils.swift
//  BloomApp
//
//  
//

import Foundation

func isRunningInSwiftUIPreview() -> Bool {
    #if DEBUG
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    #else
    return false
    #endif
}
