//
//  SellingStoreResponse.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//

import Foundation

struct SellingStoreResponse: Codable {
    var id: Int? = 0
    var storeId: Int? = 0
    var url: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case storeId = "store_id"
        case url
    }
}
