//
//  GenreMapper.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

final class GenreMapper {
    static func mapGenreResponsesToDomains(
        input genreResponses: [GenreReponse]
    ) -> [GenreModel] {
        return genreResponses.map { result in
            return mapGenreResponseToDomain(input: result)
        }
    }
    
    static func mapGenreResponseToDomain(
        input genreResponse: GenreReponse
    ) -> GenreModel {
        return GenreModel(
            id: genreResponse.id,
            name: genreResponse.name ?? "",
            slug: genreResponse.slug ?? "")
    }
}
