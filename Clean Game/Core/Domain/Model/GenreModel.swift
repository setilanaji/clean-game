//
//  GenreModel.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

struct GenreModel {
    let id: Int
    var name: String
    var slug: String
    var type: GenreType {
        get {
            return GenreType.init(rawValue: self.slug) ?? .common
        }
    }
}
    
