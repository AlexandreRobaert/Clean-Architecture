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

enum SignupFactory {
    
    static func makeRemoteAddAccount() -> AddAccountProtocol {
        let url = URL(string: "https://demo3129794.mockable.io/api/alexandre/siginup")!
        return RemoteAddAccount(url: url, httpClient: AlamofireAdapter())
    }
    
    static func makeController(addAccount: AddAccountProtocol) -> SignupViewController {
        let viewController = AppStoryboard.signup.viewController(viewController: SignupViewController.self)
        let emailValidator = EmailValidatorAdapter()
        let presenter = SignupPresenter(alertView: viewController, loadingView: viewController, emailValidator: emailValidator, addAccount: addAccount)
        viewController.signupAction = presenter.signUp(viewModel:)
        return viewController
    }
}
