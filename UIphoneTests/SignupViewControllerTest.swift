//
//  UIphoneTests.swift
//  UIphoneTests
//
//  Created by Alexandre Robaert on 27/05/23.
//

import XCTest
import UIKit
import Presentation
@testable import UIphone

final class SignupViewControllerTest: XCTestCase {

    func test_loading_oculto_ao_iniciar() throws {
        let sut = makeSut()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
    
    func test_deve_implementar_LoadingViewProtocol() throws {
        let sut = makeSut()
        XCTAssertEqual(sut is LoadingViewProtocol, true)
    }
    
    func test_deve_implementar_AlertViewProtocol() throws {
        let sut = makeSut()
        XCTAssertEqual(sut is AlertViewProtocol, true)
    }
}

extension SignupViewControllerTest {
    func makeSut() -> SignupViewController {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignupViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        sut.loadViewIfNeeded()
        return sut
    }
}
