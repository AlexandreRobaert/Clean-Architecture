//
//  SignupPresenter.swift
//  Presentation
//
//  Created by Alexandre Robaert on 07/05/23.
//

import Foundation
import Domain

class SignupPresenter {
    private let alertView: AlertViewProtocol
    private var loadingView: LoadingViewProtocol
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    
    init(alertView: AlertViewProtocol, loadingView: LoadingViewProtocol,
         emailValidator: EmailValidator, addAccount: AddAccount) {
        self.alertView = alertView
        self.loadingView = loadingView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
    }
    
    func signUp(viewModel: AddAccountModel) {
        if let messageError = validate(addAccountViewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: messageError))
        } else {
            loadingView.isLoading.toggle()
            addAccount.add(addAccountModel: viewModel) { [weak self] result in
                guard let self else { return }
                self.loadingView.isLoading.toggle()
                
                switch result {
                case .success:
                    self.alertView.showMessage(viewModel: .init(title: "Sucesso!", message: "Usuário adicionado com Sucesso!"))
                case .failure:
                    self.alertView.showMessage(viewModel: .init(title: "Erro", message: "Falha ao adicionar usuário"))
                }
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
