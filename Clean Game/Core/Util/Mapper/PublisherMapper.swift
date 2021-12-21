//
//  PublisherMapper.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

final class PublisherMapper {
    static func mapPublisherResponsesToDomains(
        input publisherResponses: [PublisherResponse]
    ) -> [PublisherModel] {
        return publisherResponses.map { result in
            return mapPublisherResponseToDomain(input: result)
        }
    }
    
    static func mapPublisherResponseToDomain(
        input publisherResponse: PublisherResponse
    ) -> PublisherModel {
        return PublisherModel(
            id: publisherResponse.id,
            name: publisherResponse.name ?? "",
            slug: publisherResponse.slug ?? ""
        )
    }
}
