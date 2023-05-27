//
//  TestFactories.swift
//  Presentation
//
//  Created by Alexandre Robaert on 27/05/23.
//

import Foundation
import Presentation

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

func makeAlertViewModelFailureAddAccount() -> AlertViewModel {
    AlertViewModel(title: "Erro", message: "Falha ao adicionar usuário")
}

func makeAlertViewModelAddAccountSucceeded() -> AlertViewModel {
    AlertViewModel(title: "Sucesso!", message: "Usuário adicionado com Sucesso!")
}
