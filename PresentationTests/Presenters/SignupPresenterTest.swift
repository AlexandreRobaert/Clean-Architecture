//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Alexandre Robaert on 07/05/23.
//

import XCTest
@testable import Presentation

final class SignupPresenterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_signup_deve_mostrar_mensagem_se_nome_for_inválido() throws {
        
        let (sut, alertViewSpy, _) = makeSut()
        let signupViewModel = SignupViewModel(name: nil, email: "any_mail", password: "any_password", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelErrorName())
    }
    
    func test_signup_deve_mostrar_mensagem_com_email_inválido() throws {
        
        let (sut, alertViewSpy, _) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: nil, password: "any_password", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutEmail())
    }
    
    func test_signup_deve_mostrar_mensagem_sem_uma_senha_obrigatoria() throws {
        
        let (sut, alertViewSpy, _) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_mail", password: nil, passwordConfirmation: nil)
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutPassword())
    }
    
    func test_signup_deve_mostrar_mensagem_com_senha_nao_confere_com_repete_senha() throws {
        
        let (sut, alertViewSpy, _) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_mail", password: "12345", passwordConfirmation: "xxxxx")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelNotMatch())
    }
    
    func test_signup_deve_chamar_o_mesmo_email_no_validator() throws {
        
        let (sut, _, emailValidatorSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "email_valido@gmail.com", password: "12345", passwordConfirmation: "12345")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signupViewModel.email)
    }
    
    func test_signup_email_invalido() throws {
        
        let (sut, alertViewSpy, emailValidatorSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "invalid_email", password: "12345", passwordConfirmation: "12345")
        emailValidatorSpy.isValid = false
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelInvalidEmail())
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

extension SignupPresenterTest {
    
    class AlertViewSpy: AlertViewProtocol {
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        
        var isValid: Bool = true
        var email: String?
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
    }
    
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy, emailValidator: EmailValidatorSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = SignupPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        return (sut, alertViewSpy, emailValidatorSpy)
    }
}


// MARK: Helpers

func makeAlertViewModelErrorName() -> AlertViewModel {
    AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório")
}

func makeAlertViewModelWithoutEmail() -> AlertViewModel {
    AlertViewModel(title: "Falha na validação", message: "Email é obrigatório")
}

func makeAlertViewModelWithoutPassword() -> AlertViewModel {
    AlertViewModel(title: "Falha na validação", message: "Senha/Confirmar Senha é obrigatória")
}

func makeAlertViewModelNotMatch() -> AlertViewModel {
    AlertViewModel(title: "Falha na validação", message: "Senhas não conferem")
}

func makeAlertViewModelInvalidEmail() -> AlertViewModel {
    AlertViewModel(title: "Falha na validação", message: "Email inválido")
}
