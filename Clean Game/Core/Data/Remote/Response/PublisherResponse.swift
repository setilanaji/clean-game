//
//  PublisherResponse.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

struct PublisherResponse: Codable {
    let id: Int
    var name: String? = ""
    var slug: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
    }
}
