//
//  FactoryAccountModels.swift
//  DataTests
//
//  Created by Alexandre Robaert on 21/05/23.
//

import Foundation
import Domain

func makeAddAccountModel(name: String = "any_name", email: String = "email_valido@gmail.com", password: String = "123456", passwordConfirmation: String = "123456")-> AddAccountModel {
    return AddAccountModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}

func makeAccountModel()-> AccountModel {
    return AccountModel(id: "1", name: "any name", email: "any email", password: "123456")
}
