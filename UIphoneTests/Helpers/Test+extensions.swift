//
//  Test+extensions.swift
//  UIphoneTests
//
//  Created by Alexandre Robaert on 28/05/23.
//

import Foundation
import UIKit

extension UIControl {
    private func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach({ action in
                (target as NSObject).perform(Selector(action))
            })
        }
    }
    
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
