//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Alexandre Robaert on 07/05/23.
//

import XCTest
@testable import Presentation

struct SignupViewModel {
    let name: String?
    let email: String?
    let password: String?
    let passwordConfirmation: String?
}

class SignupPresenter {
    var alertView: AlertViewProtocol
    
    init(alertView: AlertViewProtocol) {
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignupViewModel) {
        guard let name = viewModel.name, !name.isEmpty else {
            alertView.showMessage(viewModel: makeAlertViewModelErrorName())
            return
        }
        
        guard let email = viewModel.email, !email.isEmpty else {
            alertView.showMessage(viewModel: makeAlertViewModelWithoutEmail())
            return
        }
        
        guard let password = viewModel.password, !password.isEmpty,
              let passwordConfirmation = viewModel.passwordConfirmation,
              !passwordConfirmation.isEmpty else {
            alertView.showMessage(viewModel: makeAlertViewModelWithoutPassword())
            return
        }
        
        guard let password = viewModel.password,
              let passwordConfirmation = viewModel.passwordConfirmation,
              password.elementsEqual(passwordConfirmation) else {
            alertView.showMessage(viewModel: makeAlertViewModelNotMatch())
            return
        }
    }
}

protocol AlertViewProtocol {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    let title: String
    let message: String
}

final class SignupPresenterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_signup_deve_mostrar_mensagem_se_nome_for_inválido() throws {
        
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: nil, email: "any_mail", password: "any_password", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelErrorName())
    }
    
    func test_signup_deve_mostrar_mensagem_com_email_inválido() throws {
        
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: nil, password: "any_password", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutEmail())
    }
    
    func test_signup_deve_mostrar_mensagem_sem_uma_senha_obrigatoria() throws {
        
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_mail", password: nil, passwordConfirmation: nil)
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelWithoutPassword())
    }
    
    func test_signup_deve_mostrar_mensagem_com_senha_nao_confere_com_repete_senha() throws {
        
        let (sut, alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_mail", password: "12345", passwordConfirmation: "xxxxx")
        sut.signUp(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModelNotMatch())
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
    
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        return (SignupPresenter(alertView: alertViewSpy), alertViewSpy)
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
    AlertViewModel(title: "Falha na validação", message: "Senha é obrigatória")
}

func makeAlertViewModelNotMatch() -> AlertViewModel {
    AlertViewModel(title: "Falha na validação", message: "Senhas não conferem")
}
