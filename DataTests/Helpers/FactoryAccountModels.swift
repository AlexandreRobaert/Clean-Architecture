//
//  FactoryAccountModels.swift
//  DataTests
//
//  Created by Alexandre Robaert on 21/05/23.
//

import Foundation
import Domain

func makeAddAccountModel()-> AddAccountModel {
    return AddAccountModel(name: "any_name", email: "email_valido@gmail.com", password: "123456", passwordConfirmation: "123456")
}

func makeAccountModel()-> AccountModel {
    return AccountModel(id: "1", name: "any name", email: "any email", password: "123456")
}
