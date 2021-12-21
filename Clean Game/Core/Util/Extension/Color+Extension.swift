//
//  Color+Extension.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import UIKit

extension UIColor {
    static var colorBackground: UIColor {
        return UIColor(named: "Color-Background") ?? .white
    }
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }

    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
    
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.dropFirst())
        if !chars.isEmpty {
            self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                      green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                      blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                      alpha: alpha)
            
        } else {
            self.init(cgColor: (UIColor.systemBlue).cgColor)
        }
    }
}
