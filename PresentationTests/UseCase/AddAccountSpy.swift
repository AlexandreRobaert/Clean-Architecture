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
    private var completion: ((Result<AccountModel, DomainError>) -> Void)?
    
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
        self.addAccountModel = addAccountModel
        self.completion = completion
    }
    
    func complete(error: DomainError) {
        self.completion?(.failure(error))
    }
    
    func complete(accountModel: AccountModel) {
        self.completion?(.success(accountModel))
    }
}
