//
//  Model.swift
//  Domain
//
//  Created by Alexandre Robaert on 01/08/21.
//

import Foundation

public protocol Model: Codable {
    
}

public extension Model {
    func toData()-> Data? {
        return try? JSONEncoder().encode(self)
    }
}
