//
//  Enviroment.swift
//  Main
//
//  Created by Alexandre Robaert on 16/07/23.
//  Copyright © 2023 Alexandre Robaert. All rights reserved.
//

import Foundation

enum Enviroment: String {
    
    case baseURL = "API_BASE_URL"
    
    var value: String {
        switch self {
        case .baseURL:
            guard let value = Bundle.main.infoDictionary![self.rawValue] as? String else {
                fatalError("Key: \(self.rawValue) not found in Info.plist")
            }
            return value
        }
    }
}
