//
//  EmailValidatorAdapterTests.swift
//  ValidationsTests
//
//  Created by Alexandre Robaert on 04/06/23.
//

import XCTest
@testable import Validations

final class EmailValidatorAdapterTests: XCTestCase {

    func test_invalid_emails() throws {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: "rr"))
        XCTAssertFalse(sut.isValid(email: "rr@"))
        XCTAssertFalse(sut.isValid(email: "@teste.com"))
        XCTAssertFalse(sut.isValid(email: "e@.com"))
    }
    
    func test_valid_emails() throws {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid(email: "rrodrigo@teste.com"))
        XCTAssertTrue(sut.isValid(email: "alexandre.robaert@icloud.com"))
        XCTAssertTrue(sut.isValid(email: "alexandrenet.robaert@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "alexandre.robaert@inter.co"))
    }
}

extension EmailValidatorAdapterTests {
    
    func makeSut() -> EmailValidatorAdapter {
        return EmailValidatorAdapter()
    }
}
