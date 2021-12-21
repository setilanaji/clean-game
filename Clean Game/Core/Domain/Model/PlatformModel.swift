//
//  PlatformModel.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import UIKit

enum PlatformsType: String {
    case pc = "pc"
    case playstation = "playstation"
    case xbox = "xbox"
    case nintendo = "nintendo"
    case web = "web"
    case sega = "sega"
    case atari = "atari"
    case mac = "mac"
    case android = "android"
    case ios = "ios"
    case neogeo = "neo-geo"
    case linux = "linux"
    case threedo = "3do"
    case commodore = "commodore-amiga"
    case nothing = "nothing"
}

extension PlatformsType {
    func image() -> UIImage {
        let image = UIImage(named: self.rawValue) ?? UIImage()
        let targetSize = CGSize(width: 16, height: 16)
        return image.scalePreservingAspectRatio(targetSize: targetSize)
    }
}

struct PlatformModel {
    let id: Int
    var name: String
    var slug: String
    var type: PlatformsType {
        get {
            return PlatformsType.init(rawValue: self.slug) ?? .nothing
        }
    }
}
