//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Alexandre Robaert on 07/05/23.
//

import XCTest
@testable import Presentation
import Domain

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
        sut.signUp(viewModel: makeSignupViewModel(name: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelErrorName())
    }
    
    func test_signup_deve_mostrar_mensagem_com_email_inválido_quando_sem_email() throws {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeSignupViewModel(email: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutEmail())
    }
    
    func test_signup_deve_mostrar_mensagem_sem_uma_senha_obrigatoria() throws {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeSignupViewModel(password: nil, passwordConfirmation: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutPassword())
    }
    
    func test_signup_deve_mostrar_mensagem_com_senha_nao_confere_com_repete_senha() throws {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signupViewModel = makeSignupViewModel(password: "senha errada")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelNotMatch())
    }
    
    func test_signup_deve_chamar_o_mesmo_email_no_validator() throws {
        
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signupViewModel = makeSignupViewModel()
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signupViewModel.email)
    }
    
    func test_signup_deve_mostrar_mensagem_com_email_inválido() throws {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        emailValidatorSpy.isValid = false
        sut.signUp(viewModel: makeSignupViewModel())
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelInvalidEmail())
    }
    
    func test_signup_deve_chamar_addAccount_com_dados_corretos() throws {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccountSpy: addAccountSpy)
        sut.signUp(viewModel: makeSignupViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
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
    
    class AddAccountSpy: AddAccount {
        var addAccountModel: AddAccountModel?
        func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
        }
    }
    
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(),
                 emailValidator: EmailValidatorSpy = EmailValidatorSpy(),
                 addAccountSpy: AddAccountSpy = AddAccountSpy()) -> SignupPresenter {
        return SignupPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccountSpy)
    }
    
    func makeSignupViewModel(name: String? = "any_name",
                             email: String? = "email_valido@gmail.com",
                             password: String? = "123456",
                             passwordConfirmation: String? = "123456") -> SignupViewModel {
        
        return SignupViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
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
}
