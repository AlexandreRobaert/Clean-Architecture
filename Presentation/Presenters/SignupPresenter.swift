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
    private var loadingView: LoadingViewProtocol
    private let emailValidator: EmailValidatorProtocol
    private let addAccount: AddAccountProtocol
    
    public init(alertView: AlertViewProtocol, loadingView: LoadingViewProtocol,
         emailValidator: EmailValidatorProtocol, addAccount: AddAccountProtocol) {
        self.alertView = alertView
        self.loadingView = loadingView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
    }
    
    public func signUp(viewModel: AddAccountModel) {
        if let messageError = validate(addAccountViewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: messageError))
        } else {
            loadingView.isLoading = true
            addAccount.add(addAccountModel: viewModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    self.alertView.showMessage(viewModel: .init(title: "Sucesso!", message: "Usuário adicionado com Sucesso!"))
                case .failure:
                    self.alertView.showMessage(viewModel: .init(title: "Erro", message: "Falha ao adicionar usuário"))
                }
                self.loadingView.isLoading = false
            }
        }
    }
    
    private func validate(addAccountViewModel: AddAccountModel) -> String? {
        if !emailValidator.isValid(email: addAccountViewModel.email) {
            return "Email inválido"
        }
        
        if addAccountViewModel.name.isEmpty {
            return "Nome é obrigatório"
        }

        if addAccountViewModel.email.isEmpty {
            return "Email é obrigatório"
        }

        if addAccountViewModel.password.isEmpty || addAccountViewModel.passwordConfirmation.isEmpty {
            return "Senha/Confirmar Senha é obrigatória"
        }

        if !addAccountViewModel.password.elementsEqual(addAccountViewModel.passwordConfirmation) {
            return "Senhas não conferem"
        }
        return nil
    }
}
