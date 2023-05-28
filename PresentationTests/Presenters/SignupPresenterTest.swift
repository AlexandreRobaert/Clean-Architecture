//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Alexandre Robaert on 07/05/23.
//

import XCTest
import Domain
@testable import Presentation

final class SignupPresenterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_signup_deve_mostrar_mensagem_se_nome_for_inválido() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeAddAccountModel(name: ""))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelErrorName())
    }
    
    func test_signup_deve_mostrar_mensagem_com_email_inválido_quando_sem_email() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeAddAccountModel(email: ""))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutEmail())
    }
    
    func test_signup_deve_mostrar_mensagem_sem_uma_senha_obrigatoria() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeAddAccountModel(password: ""))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutPassword())
    }
    
    func test_signup_deve_mostrar_mensagem_com_senha_nao_confere_com_repete_senha() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeAddAccountModel(password: "abc", passwordConfirmation: "cba"))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelNotMatch())
    }
    
    func test_signup_deve_chamar_o_mesmo_email_no_validator() throws {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let addAccountModel = makeAddAccountModel()
        sut.signUp(viewModel: addAccountModel)
        XCTAssertEqual(emailValidatorSpy.email, addAccountModel.email)
    }
    
    func test_signup_deve_mostrar_mensagem_com_email_inválido() throws {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        emailValidatorSpy.isValid = false
        sut.signUp(viewModel: makeAddAccountModel())
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelInvalidEmail())
    }
    
    func test_signup_deve_chamar_addAccount_com_dados_corretos() throws {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccountSpy: addAccountSpy)
        sut.signUp(viewModel: makeAddAccountModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
    
    func test_signup_deve_mostrar_mensagem_com_falha_no_add_do_usecase() throws {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccountSpy: addAccountSpy)
        sut.signUp(viewModel: makeAddAccountModel())
        addAccountSpy.complete(error: .unexpected)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelFailureAddAccount())
    }
    
    func test_signup_deve_mostrar_mensagem_com_sucesso_no_add_do_usecase() throws {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccountSpy: addAccountSpy)
        sut.signUp(viewModel: makeAddAccountModel())
        addAccountSpy.complete(accountModel: makeAccountModel())
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelAddAccountSucceeded())
    }
    
    func test_signup_deve_mostrar_e_ocultar_loading_depois_de_chamar_signUp() throws {
        let addAccountSpy = AddAccountSpy()
        let loadingView = LoadingViewSpy()
        let sut = makeSut(addAccountSpy: addAccountSpy, loadingViewSpy: loadingView)
        sut.signUp(viewModel: makeAddAccountModel())
        XCTAssertEqual(loadingView.isLoading, true)
        addAccountSpy.complete(error: .unexpected)
        XCTAssertEqual(loadingView.isLoading, false)
    }
}

extension SignupPresenterTest {
    
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(),
                 emailValidator: EmailValidatorSpy = EmailValidatorSpy(),
                 addAccountSpy: AddAccountSpy = AddAccountSpy(),
                 loadingViewSpy: LoadingViewSpy = LoadingViewSpy(),
                 file: StaticString = #file, line: UInt = #line) -> SignupPresenter {
        
        let sut = SignupPresenter(alertView: alertView, loadingView: loadingViewSpy,
                                  emailValidator: emailValidator, addAccount: addAccountSpy)
        checkMemoryLeak(instance: sut, file: file, line: line)
        return sut
    }
}
