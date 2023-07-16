//
//  UseCaseFactory.swift
//  Main
//
//  Created by Alexandre Robaert on 16/07/23.
//  Copyright © 2023 Alexandre Robaert. All rights reserved.
//

import Foundation
import Domain
import Data
import Infra

enum UseCaseFactory {
    
    private static let httpClient: HttpPostClient = AlamofireAdapter()
    private static let apiBaseURL = Enviroment.baseURL.value
    
    static func makeRemoteAddAccount() -> AddAccountProtocol {
        let url = URL(string: "\(apiBaseURL)/siginup")!
        return RemoteAddAccount(url: url, httpClient: httpClient)
    }
}
