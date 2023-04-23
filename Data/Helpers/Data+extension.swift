//
//  Data+extension.swift
//  Data
//
//  Created by Alexandre Robaert on 23/04/23.
//

import Foundation

public extension Data {
    func parse<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
