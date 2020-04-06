//
//  FontLoader.swift
//  Ojol
//
//  Created by Muis on 17/02/20.
//

import UIKit

public class FontLoader {
    private enum Error: Swift.Error {
        case error(String)
    }
    
    /// Register fonts
    ///
    /// - Parameter fonts: Font names
    static func registerFonts(fonts: [String]) throws {
        let bundle = Bundle(for: FontLoader.self)
        let urls = fonts.compactMap({ bundle.url(forResource: $0, withExtension: "ttf") })
        try urls.forEach { (url) in
            let data = try Data.init(contentsOf: url)
            guard let provider = CGDataProvider.init(data: data as CFData) else { throw Error.error("CGDataProvider nil") }
            guard let font = CGFont.init(provider) else { throw Error.error("CGFont nil") }
            var error: Unmanaged<CFError>?
            guard CTFontManagerRegisterGraphicsFont(font, &error) else {
                throw error!.takeUnretainedValue()
            }
        }
    }
}
