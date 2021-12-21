//
//  GameModel.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

struct GameModel {
    let id: Int
    var name: String
    var slug: String
    var released: String
    var rating: Float
    var ratingsCount: Int
    var backgroundImage: String
    var description: String
    var website: String
    var parentPlatforms: [BasePlatformModel] = []
    var platforms: [BasePlatformModel] = []
    var genres: [GenreModel] = []
    var publishers: [PublisherModel] = []
    var stores: [BaseStoreModel]
    var reviewsCount: Int
    var isFavorite = false
}
