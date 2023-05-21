//
//  SignupPresenter.swift
//  Presentation
//
//  Created by Alexandre Robaert on 07/05/23.
//

import Foundation

public class SignupPresenter {
    private var alertView: AlertViewProtocol
    private var emailValidator: EmailValidator
    
    public init(alertView: AlertViewProtocol, emailValidator: EmailValidator) {
        self.alertView = alertView
        self.emailValidator = emailValidator
    }
    
    public func signUp(viewModel: SignupViewModel) {
        
        let result = validate(signupViewModel: viewModel)
        if result.isValid {
            // Adiciona Usuário
        } else if let alertViewModel = result.alertViewModel {
            alertView.showMessage(viewModel: alertViewModel)
        }
    }
    
    private func validate(signupViewModel: SignupViewModel) -> (isValid: Bool, alertViewModel: AlertViewModel?) {
        guard let name = signupViewModel.name, !name.isEmpty else {
            return (false, AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
        }
        
        guard let email = signupViewModel.email, !email.isEmpty else {
            return (false, AlertViewModel(title: "Falha na validação", message: "Email é obrigatório"))
        }
        
        guard let password = signupViewModel.password, !password.isEmpty,
              let passwordConfirmation = signupViewModel.passwordConfirmation,
              !passwordConfirmation.isEmpty else {
            return (false, AlertViewModel(title: "Falha na validação", message: "Senha/Confirmar Senha é obrigatória"))
        }
        
        if let password = signupViewModel.password,
           let passwordConfirmation = signupViewModel.passwordConfirmation,
           !password.elementsEqual(passwordConfirmation) {
            
            return (false, AlertViewModel(title: "Falha na validação", message: "Senhas não conferem"))
        }
        
        if !emailValidator.isValid(email: email) {
            return (false, AlertViewModel(title: "Falha na validação", message: "Email inválido"))
        }
        return (true, nil)
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
