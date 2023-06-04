//
//  EmailValidatorAdapter.swift
//  Validations
//
//  Created by Alexandre Robaert on 04/06/23.
//

import Foundation
import Presentation

public final class EmailValidatorAdapter: EmailValidatorProtocol {
    
    private let pattern = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
    
    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf8.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: email, range: range) != nil
    }
}
