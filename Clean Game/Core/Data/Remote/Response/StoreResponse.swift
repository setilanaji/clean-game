//
//  StoreResponse.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/5.
//

import Foundation

struct BaseStoreResponse: Codable {
    var id: Int? = 0
    var url: String? = ""
    var store: StoreResponse? = StoreResponse()
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case store
    }
}

struct StoreResponse: Codable {
    var id: Int? = 0
    var name: String? = ""
    var slug: String? = ""
    var domain: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case domain
    }
}
