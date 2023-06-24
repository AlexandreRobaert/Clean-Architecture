//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Alexandre Robaert on 01/08/21.
//

import Foundation
import Domain

public final class RemoteAddAccount: AddAccountProtocol {
    
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel) async throws -> AccountModel {
        
        let data = try await httpClient.post(to: url, with: addAccountModel.toData())
        guard let accountModel: AccountModel = data.parse()  else {
            throw HttpError.parseError
        }
        
        return accountModel
    }
}
