//
//  PersistenceError.swift
//  BloomApp
//
//  
//

enum PersistenceError: Error {
    case couldNotReadSecurityScoped
    case couldNotReadData
    case invalidBloomURL(String)
}
