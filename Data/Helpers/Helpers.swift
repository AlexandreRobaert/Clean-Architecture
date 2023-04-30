//
//  Helpers.swift
//  Data
//
//  Created by Alexandre Robaert on 30/04/23.
//

import Foundation

public func validData() -> Data? {
    #"{"name": "Alexandre"}"#.data(using: .utf8)
}

public func invalidData() -> Data? {
    "inválido".data(using: .utf8)
}

public func makeURL() -> URL {
    URL(string: "https://any-url.com")!
}

public func makeError() -> Error {
    return NSError(domain: "Error", code: 0)
}
