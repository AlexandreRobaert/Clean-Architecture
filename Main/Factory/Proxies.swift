//
//  SignupFactory.swift
//  Main
//
//  Created by Alexandre Robaert on 04/06/23.
//

import Foundation
import UIKit
import UIphone
import Presentation
import Data
import Validations
import Infra
import Domain

final class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(instance: T) {
        self.instance = instance
    }
}

extension WeakVarProxy: AlertViewProtocol where T: AlertViewProtocol {
    func showMessage(viewModel: Presentation.AlertViewModel) {
        instance?.showMessage(viewModel: viewModel)
    }
}

extension WeakVarProxy: LoadingViewProtocol where T: LoadingViewProtocol {
    var isLoading: Bool {
        get {
            instance?.isLoading ?? false
        }
        set(newValue) {
            instance?.isLoading = newValue
        }
    }
}
