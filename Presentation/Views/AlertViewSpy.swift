//
//  AlertViewSpy.swift
//  Presentation
//
//  Created by Alexandre Robaert on 27/05/23.
//

import Foundation

class AlertViewSpy: AlertViewProtocol {
    var viewModel: AlertViewModel?
    
    func showMessage(viewModel: AlertViewModel) {
        self.viewModel = viewModel
    }
}
