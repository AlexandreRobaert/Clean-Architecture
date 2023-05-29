//
//  SignupViewController.swift
//  UIphone
//
//  Created by Alexandre Robaert on 27/05/23.
//

import UIKit
import Domain
import Presentation

public final class SignupViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var fields: [UITextField]!
    
    public var isLoading: Bool = false {
        didSet {
            toogleLoading()
        }
    }
    public var signupAction: ((_ viewModel: AddAccountModel) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        saveButton.layer.cornerRadius = 5.0
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
    }
    
    @objc
    private func saveButtonTap() {
        let addAccountModel: AddAccountModel = .init(name: fields[0].text!, email: fields[1].text!, password: fields[2].text!, passwordConfirmation: fields[3].text!)
        signupAction?(addAccountModel)
    }
}

extension SignupViewController: LoadingViewProtocol, AlertViewProtocol {

    private func toogleLoading() {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    public func showMessage(viewModel: AlertViewModel) {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
