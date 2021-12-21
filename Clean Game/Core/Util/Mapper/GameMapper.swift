//
//  GameMapper.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation
import RealmSwift

final class GameMapper {
    static func mapGameResponsesToDomains(
        input gameResponses: [GameResponse]
    ) -> [GameModel] {
        return gameResponses.map { result in
            return mapGameResponseToDomain(input: result)
        }
    }
    
    static func mapGameResponseToDomain(
        input gameResponse: GameResponse
    ) -> GameModel {
        return GameModel(
            id: gameResponse.id,
            name: gameResponse.name ?? "",
            slug: gameResponse.slug ?? "",
            released: gameResponse.released ?? "",
            rating: gameResponse.rating ?? 0,
            ratingsCount: gameResponse.ratingsCount ?? 0,
            backgroundImage: gameResponse.backgroundImage ?? "",
            description: gameResponse.description ?? "",
            website: gameResponse.website ?? "",
            genres: GenreMapper.mapGenreResponsesToDomains(input: gameResponse.genres ?? []),
            stores: StoreMapper.mapBaseStoreResponsesToDomains(input: gameResponse.stores ?? []),
            reviewsCount: gameResponse.reviewsCount ?? 0
        )
    }
    
    static func mapfavoriteEntityToDomain(
        input favoriteEntity: FavoriteEntity
    ) -> GameModel {
        return GameModel(
            id: Int(favoriteEntity.id) ?? 0,
            name: favoriteEntity.name,
            slug: favoriteEntity.slug,
            released: favoriteEntity.released,
            rating: favoriteEntity.rating,
            ratingsCount: favoriteEntity.ratingsCount,
            backgroundImage: favoriteEntity.backgroundImage,
            description: favoriteEntity.description,
            website: favoriteEntity.website,
            stores: [],
            reviewsCount: favoriteEntity.reviewsCount,
            isFavorite: true
        )
    }
    
    static func mapFavoriteEntitiesToDomains(
        input favoriteEntities: [FavoriteEntity]
    ) -> [GameModel] {
        return favoriteEntities.map { entity in
            return mapfavoriteEntityToDomain(input: entity)
        }
    }
    
    static func mapScreenshotResponseToDomain(
        input screenshotResponse: ScreenshotResponse
    ) -> ScreenshotModel {
        return ScreenshotModel(
            id: screenshotResponse.id,
            image: screenshotResponse.image)
    }
    
    static func mapScreenshotResponsesToDomains(
        input screenshotResponses: [ScreenshotResponse]
    ) -> [ScreenshotModel] {
        return screenshotResponses.map { response in
            return mapScreenshotResponseToDomain(input: response)
        }
    }
    
    static func mapGameDomainToEntity(
        input gameModel: GameModel
    ) -> FavoriteEntity {
        let newFavorite = FavoriteEntity()
        newFavorite.name = gameModel.name
        newFavorite.id = String(gameModel.id)
        newFavorite.slug = gameModel.slug
        newFavorite.rating = gameModel.rating
        newFavorite.ratingsCount = gameModel.ratingsCount
        newFavorite.reviewsCount = gameModel.reviewsCount
        newFavorite.gameDescription = gameModel.description
        newFavorite.released = gameModel.released
        newFavorite.website = gameModel.website
        newFavorite.backgroundImage = gameModel.backgroundImage
        return newFavorite
    }
    
}
