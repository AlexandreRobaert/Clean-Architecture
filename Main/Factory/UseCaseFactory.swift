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
    
    static func makeRemoteAddAccount() -> AddAccountProtocol {
        let url = URL(string: "https://demo3129794.mockable.io/api/alexandre/siginup")!
        return RemoteAddAccount(url: url, httpClient: AlamofireAdapter())
    }
}
