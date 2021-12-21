//
//  PlatformMapper.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

final class PlatformMapper {
    static func mapBasePlatformResponseToDomain(
        input basePlatformResponse: BasePlatformResponse
    ) -> BasePlatformModel {
        return BasePlatformModel(platform: mapPlatformResponseToDomain(input: basePlatformResponse.platform))
    }
    
    static func mapPlatformResponsesToDomains(
        input platformResponses: [PlatformResponse]
    ) -> [PlatformModel] {
        return platformResponses.map { result in
            return mapPlatformResponseToDomain(input: result)
        }
    }
    
    static func mapPlatformResponseToDomain(
        input platformResponse: PlatformResponse
    ) -> PlatformModel {
        return PlatformModel(
            id: platformResponse.id,
            name: platformResponse.name ?? "",
            slug: platformResponse.slug ?? ""
        )
    }
}
