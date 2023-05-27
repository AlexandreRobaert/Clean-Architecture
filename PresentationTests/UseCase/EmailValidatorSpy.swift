//
//  EmailValidatorSpy.swift
//  Presentation
//
//  Created by Alexandre Robaert on 27/05/23.
//

import Foundation
import Presentation

class EmailValidatorSpy: EmailValidatorProtocol {
    
    var isValid: Bool = true
    var email: String?
    func isValid(email: String) -> Bool {
        self.email = email
        return isValid
    }
}
