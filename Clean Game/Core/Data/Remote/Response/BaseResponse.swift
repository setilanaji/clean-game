//
//  BaseResponse.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    var count: Int? = 0
    var next: String? = ""
    var previous: String? = ""
    var result: [T]

    enum CodingKeys: String, CodingKey {
        case count
        case next
        case result = "results"
        case previous
    }
}
