//
//  SignupIntegrationTests.swift
//  SignupIntegrationTests
//
//  Created by Alexandre Robaert on 16/07/23.
//  Copyright © 2023 Alexandre Robaert. All rights reserved.
//

import XCTest
@testable import Main

final class SignupIntegrationTests: XCTestCase {

    func testUI_presentation_integration() throws {
        let sut = SignupComposer.composeViewController(addAccount: AddAccountSpy())
        checkMemoryLeak(instance: sut, file: #file, line: #line)
    }
}
