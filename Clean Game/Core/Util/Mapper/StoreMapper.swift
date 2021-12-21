//
//  StoreMapper.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/5.
//

import Foundation


final class StoreMapper {
    static func mapBaseStoreResponsesToDomains(
        input baseStoreResponses: [BaseStoreResponse]
    ) -> [BaseStoreModel] {
        return baseStoreResponses.map { result in
            return mapBaseStoreResponseToDomain(input: result)
        }
    }
    
    static func mapBaseStoreResponseToDomain(
        input baseStoreResponse: BaseStoreResponse
    ) -> BaseStoreModel {
        return BaseStoreModel(
            id: baseStoreResponse.id ?? 0,
            url: baseStoreResponse.url ?? "",
            store: mapStoreResponseToDomain(input: baseStoreResponse.store ?? StoreResponse()))
    }
    
    static func mapStoreResponseToDomain(
        input storeResponse: StoreResponse
    ) -> StoreModel {
        return StoreModel(
            id: storeResponse.id ?? 0,
            name: storeResponse.name ?? "",
            slug: storeResponse.slug ?? "",
            domain: storeResponse.domain ?? "")
    }
    
    static func mapSellingStoreResponseToDomain(
        input storeResponse: SellingStoreResponse
    ) -> SellingStoreModel {
        return SellingStoreModel(
            id: storeResponse.id ?? 0,
            storeId: storeResponse.storeId ?? 0,
            url: storeResponse.url ?? "")
    }
    
    static func mapSellingStoreResponsesToDomain(
        input storeResponses: [SellingStoreResponse]
    ) -> [SellingStoreModel] {
        return storeResponses.map { mapSellingStoreResponseToDomain(input: $0) }
    }
}
