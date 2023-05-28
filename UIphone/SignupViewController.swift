//
//  SignupViewController.swift
//  UIphone
//
//  Created by Alexandre Robaert on 27/05/23.
//

import UIKit
import Presentation

public final class SignupViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    public var isLoading: Bool = false {
        didSet {
            toogleLoading()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
}
