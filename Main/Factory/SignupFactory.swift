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

enum SignupFactory {
    static func makeController() -> SignupViewController {
        let viewController = AppStoryboard.signup.viewController(viewController: SignupViewController.self)
        let emailValidator = EmailValidatorAdapter()
        let url = URL(string: "https://demo3129794.mockable.io/api/alexandre/siginup")!
        let remoteAddAccount = RemoteAddAccount(url: url, httpClient: AlamofireAdapter())
        let presenter = SignupPresenter(alertView: viewController, loadingView: viewController, emailValidator: emailValidator, addAccount: remoteAddAccount)
        viewController.signupAction = presenter.signUp(viewModel:)
        return viewController
    }
}
