//
//  AlertViewProtocol.swift
//  Presentation
//
//  Created by Alexandre Robaert on 20/05/23.
//

import Foundation

protocol AlertViewProtocol {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    public let title: String
    public let message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
