//
//  AddAccount.swift
//  Domain
//
//  Created by Alexandre Robaert on 31/07/21.
//

import Foundation

struct AddAccountModel: Codable {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}

protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void)
}
