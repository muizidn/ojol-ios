//
//  UIFont.swift
//  Ojol
//
//  Created by Muis on 17/02/20.
//

import UIKit

extension UIFont {
    static func compactRounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont =  UIFont.systemFont(ofSize: size, weight: weight)
        if #available(iOS 13.0, *) {
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                return UIFont.init(descriptor: descriptor, size: size)
            }
        } else {
            // Fallback on earlier versions
        }
        return systemFont
    }
}
