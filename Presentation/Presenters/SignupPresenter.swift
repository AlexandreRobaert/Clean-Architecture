//
//  SignupPresenter.swift
//  Presentation
//
//  Created by Alexandre Robaert on 07/05/23.
//

import Foundation
import Domain

public class SignupPresenter {
    private let alertView: AlertViewProtocol
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    
    public init(alertView: AlertViewProtocol, emailValidator: EmailValidator, addAccount: AddAccount) {
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
    }
    
    public func signUp(viewModel: SignupViewModel) {
        
        let result = validate(signupViewModel: viewModel)
        if let addAccountModel = result.addAccountModel {
            addAccount.add(addAccountModel: addAccountModel) { _ in }
        } else if let alertViewModel = result.alertViewModel {
            alertView.showMessage(viewModel: alertViewModel)
        }
    }
    
    private func validate(signupViewModel: SignupViewModel) -> (addAccountModel: AddAccountModel?, alertViewModel: AlertViewModel?) {
        guard let name = signupViewModel.name, !name.isEmpty else {
            return (nil, AlertViewModel(title: "Falha na validação", message: "Nome é obrigatório"))
        }
        
        guard let email = signupViewModel.email, !email.isEmpty else {
            return (nil, AlertViewModel(title: "Falha na validação", message: "Email é obrigatório"))
        }
        
        guard let password = signupViewModel.password, !password.isEmpty,
              let passwordConfirmation = signupViewModel.passwordConfirmation,
              !passwordConfirmation.isEmpty else {
            return (nil, AlertViewModel(title: "Falha na validação", message: "Senha/Confirmar Senha é obrigatória"))
        }
        
        if let password = signupViewModel.password,
           let passwordConfirmation = signupViewModel.passwordConfirmation,
           !password.elementsEqual(passwordConfirmation) {
            
            return (nil, AlertViewModel(title: "Falha na validação", message: "Senhas não conferem"))
        }
        
        if !emailValidator.isValid(email: email) {
            return (nil, AlertViewModel(title: "Falha na validação", message: "Email inválido"))
        }
        let addAccountModel = AddAccountModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
        return (addAccountModel, nil)
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
