//
//  ScreenshotResponse.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/4.
//

import Foundation

struct ScreenshotResponse: Codable{
    var id: Int
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
    }
}
