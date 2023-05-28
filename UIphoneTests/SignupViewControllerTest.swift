//
//  UIphoneTests.swift
//  UIphoneTests
//
//  Created by Alexandre Robaert on 27/05/23.
//

import XCTest
import UIKit
import Presentation
import Domain
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
    
    func test_deve_chamar_signup_quando_clicar_no_botao_com_dados_corretos() throws {
        var addAccoutModel: AddAccountModel?
        let sut = makeSut { addAccoutModel = $0 }
        sut.saveButton.simulateTap()
        let name = sut.fields[0].text!
        let email = sut.fields[1].text!
        let password = sut.fields[2].text!
        let passwordConfirmation = sut.fields[3].text!
        XCTAssertEqual(addAccoutModel, .init(name: name, email: email, password: password,
                                             passwordConfirmation: passwordConfirmation))
    }
}

extension SignupViewControllerTest {
    func makeSut(signupActionSpy: ((AddAccountModel) -> Void)? = nil) -> SignupViewController {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignupViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        sut.signupAction = signupActionSpy
        sut.loadViewIfNeeded()
        return sut
    }
}

private extension UIControl {
    private func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach({ action in
                (target as NSObject).perform(Selector(action))
            })
        }
    }
    
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
