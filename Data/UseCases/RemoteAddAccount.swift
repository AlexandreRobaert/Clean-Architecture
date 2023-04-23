//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Alexandre Robaert on 01/08/21.
//

import Foundation
import Domain

public final class RemoteAddAccount: AddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void ){
        httpClient.post(to: url, with: addAccountModel.toData()) { result in
            switch result {
            case .failure:
                completion(.failure(.unexpected))
            case .success(let data):
                guard let accountModel: AccountModel = data.parse() else {
                    return completion(.failure(.unexpected))
                }
                completion(.success(accountModel))
            }
        }
    }
}
