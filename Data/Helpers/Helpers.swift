//
//  Helpers.swift
//  Data
//
//  Created by Alexandre Robaert on 30/04/23.
//

import Foundation

public func makeValidData() -> Data {
    #"{"name": "Alexandre"}"#.data(using: .utf8) ?? Data()
}

public func makeInvalidData() -> Data {
    "inválido".data(using: .utf8)!
}

public func makeEmptyData() -> Data {
    "".data(using: .utf8)!
}

public func makeURL() -> URL {
    URL(string: "https://any-url.com")!
}

public func makeError() -> Error {
    return NSError(domain: "Error", code: 0)
}

public func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    .init(url: makeURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
