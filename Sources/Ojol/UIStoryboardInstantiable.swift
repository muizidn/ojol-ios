//
//  UIStoryboardInstantiable.swift
//  Ojol
//
//  Created by Muis on 04/03/20.
//

import UIKit

protocol UIStoryboardInstantiable: UIViewController {}

extension UIStoryboardInstantiable {
    /// Instantiate from Storyboard
    static func instantiate() -> Self {
        let st = UIStoryboard(name: "\(Self.self)", bundle: nil)
        guard let vc =  st.instantiateInitialViewController() else {
            fatalError("cannot instatiate from storyboard, you may forgot to set initial viewController?")
        }
        
        guard let this = vc as? Self else { fatalError("\(vc) is not \(Self.self)")}
        return this
    }
}
