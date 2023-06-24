//
//  AddAccountSpy.swift
//  Presentation
//
//  Created by Alexandre Robaert on 27/05/23.
//

import Foundation
import Domain

class AddAccountSpy: AddAccountProtocol {
    var addAccountModel: AddAccountModel?
    private var accountModelResult: (accountModel: AccountModel?, error: DomainError?)?
    
    func add(addAccountModel: AddAccountModel) async throws -> AccountModel {
        self.addAccountModel = addAccountModel
        guard let accountModel = accountModelResult?.accountModel, accountModelResult?.error != nil else {
            if let error = accountModelResult?.error {
                throw error
            }
            throw DomainError.unexpected
        }
        return accountModel
    }
    
    func complete(error: DomainError) {
        self.accountModelResult?.error = error
    }
    
    func complete(accountModel: AccountModel) {
        self.accountModelResult?.accountModel = accountModel
    }
}
