//
//  EmailValidatorAdapterTests.swift
//  ValidationsTests
//
//  Created by Alexandre Robaert on 04/06/23.
//

import XCTest
@testable import Validations

final class EmailValidatorAdapterTests: XCTestCase {

    func test_invalid_email() throws {
        let sut = EmailValidatorAdapter()
        XCTAssertFalse(sut.isValid(email: "rr"))
        XCTAssertFalse(sut.isValid(email: "rr@"))
        XCTAssertFalse(sut.isValid(email: "@teste.com"))
        XCTAssertFalse(sut.isValid(email: "e@.com"))
    }
}
