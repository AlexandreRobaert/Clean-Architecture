//
//  SignupPresenter.swift
//  Presentation
//
//  Created by Alexandre Robaert on 07/05/23.
//

import Foundation

public class SignupPresenter {
    private var alertView: AlertViewProtocol
    
    public init(alertView: AlertViewProtocol) {
        self.alertView = alertView
    }
    
    public func signUp(viewModel: SignupViewModel) {
        guard let name = viewModel.name, !name.isEmpty else {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
            return
        }
        
        guard let email = viewModel.email, !email.isEmpty else {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Email é obrigatório"))
            return
        }
        
        guard let password = viewModel.password, !password.isEmpty,
              let passwordConfirmation = viewModel.passwordConfirmation,
              !passwordConfirmation.isEmpty else {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Senha/Confirmar Senha é obrigatória"))
            return
        }
        
        guard let password = viewModel.password,
              let passwordConfirmation = viewModel.passwordConfirmation,
              password.elementsEqual(passwordConfirmation) else {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "Senhas não conferem"))
            return
        }
    }
}

public struct SignupViewModel {
    public let name: String?
    public let email: String?
    public let password: String?
    public let passwordConfirmation: String?
    
    public init(name: String?, email: String?, password: String?, passwordConfirmation: String?) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
