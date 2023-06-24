//
//  AddAccount.swift
//  Domain
//
//  Created by Alexandre Robaert on 31/07/21.
//

import Foundation

public protocol AddAccountProtocol {
    func add(addAccountModel: AddAccountModel) async throws -> AccountModel
}

public struct AddAccountModel: Model {
    
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
    
    public init(name: String, email: String, password: String, passwordConfirmation: String) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
