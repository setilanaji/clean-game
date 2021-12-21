//
//  BasePlatformResponse.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

struct BasePlatformResponse: Codable {
    let platform: PlatformResponse
    
    enum CodingKeys: String, CodingKey {
        case platform
    }
}
