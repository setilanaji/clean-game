//
//  GameReponse.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

struct GameResponse: Codable {
    let id: Int
    var name: String? = ""
    var slug: String? = ""
    var released: String? = ""
    var rating: Float? = 0
    var ratingsCount: Int? = 0
    var backgroundImage: String? = ""
    var description: String? = ""
    var website: String? = ""
    var parentPlatforms: [BasePlatformResponse]? = []
    var platforms: [BasePlatformResponse]? = []
    var genres: [GenreReponse]? = []
    var publishers: [PublisherResponse]? = []
    var stores: [BaseStoreResponse]? = []
    var reviewsCount: Int? = 0

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case released
        case rating
        case ratingsCount = "ratings_count"
        case backgroundImage = "background_image"
        case description = "description_raw"
        case website
        case parentPlatforms = "parent_platforms"
        case platforms
        case genres
        case publishers
        case stores
        case reviewsCount = "reviews_count"
    }
}
