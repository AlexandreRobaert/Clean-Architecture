//
//  AccountModel.swift
//  Domain
//
//  Created by Alexandre Robaert on 31/07/21.
//

import Foundation

public struct AccountModel: Model {
    
    public var id: String
    public var email: String
    public var password: String
    
    public init(id: String, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}
