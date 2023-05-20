//
//  AlertViewProtocol.swift
//  Presentation
//
//  Created by Alexandre Robaert on 20/05/23.
//

import Foundation

public protocol AlertViewProtocol {
    func showMessage(viewModel: AlertViewModel)
}

public struct AlertViewModel: Equatable {
    public let title: String
    public let message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
