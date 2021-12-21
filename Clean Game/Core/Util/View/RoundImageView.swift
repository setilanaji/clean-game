//
//  RoundImageView.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/28.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
