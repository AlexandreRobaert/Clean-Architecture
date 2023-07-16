//
//  SignupComposer.swift
//  Main
//
//  Created by Alexandre Robaert on 16/07/23.
//  Copyright © 2023 Alexandre Robaert. All rights reserved.
//

import Foundation
import Domain
import UIphone
import Validations
import Presentation

enum SignupComposer {
    
    static func composeViewController(addAccount: AddAccountProtocol) -> SignupViewController {
        let viewController = AppStoryboard.signup.viewController(viewController: SignupViewController.self)
        let emailValidator = EmailValidatorAdapter()
        let presenter = SignupPresenter(alertView: WeakVarProxy(instance: viewController),
                                        loadingView: WeakVarProxy(instance: viewController),
                                        emailValidator: emailValidator, addAccount: addAccount)
        viewController.signupAction = presenter.signUp(viewModel:)
        return viewController
    }
}
