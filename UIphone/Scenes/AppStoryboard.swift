//
//  UIViewController+extension.swift
//  UIphone
//
//  Created by Alexandre Robaert on 04/06/23.
//

import UIKit

public enum AppStoryboard: String {
    case signup = "SignUp"
    
    private var instance: UIStoryboard {
        switch self {
        case .signup:
            return UIStoryboard(name: self.rawValue, bundle: bundle)
        }
    }
    
    private var bundle: Bundle {
        switch self {
        case .signup:
            return Bundle(identifier: "com.robaert.alexandre.UIphone")!
        }
    }
    
    public func viewController<T>(viewController: T.Type) -> T where T: UIViewController {
        guard let viewController = instance.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("")
        }
        return viewController
    }
}
