//
//  EmailValidator.swift
//  Presentation
//
//  Created by Alexandre Robaert on 20/05/23.
//

import Foundation

public protocol EmailValidator {
    
    func isValid(email: String) -> Bool
}
