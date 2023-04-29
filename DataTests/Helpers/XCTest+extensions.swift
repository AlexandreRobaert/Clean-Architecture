//
//  XCTest+extensions.swift
//  DataTests
//
//  Created by Alexandre Robaert on 29/04/23.
//

import Foundation
import XCTest

extension XCTestCase {
    func checkMemoryLeak(instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
