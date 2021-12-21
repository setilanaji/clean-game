//
//  GenreType.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/2.
//

import UIKit

enum GenreType: String {
    case action = "action"
    case indie = "indie"
    case casual = "casual"
    case strategy = "strategy"
    case puzzle = "puzzle"
    case adventure = "adventure"
    case rpg = "rpg"
    case simulation = "simulation"
    case shooter = "shooter"
    case common = "common"
}

extension GenreType {
    func icon() -> UIImage {
        let image = UIImage(named: self.rawValue + "-icon") ?? UIImage()
        let targetSize = CGSize(width: 42, height: 42)
        return image.scalePreservingAspectRatio(targetSize: targetSize)
    }
}
