//
//  GameRequest.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/1.
//

import Foundation

struct GameRequest {
    var search: String = ""
    var genres: [String] = []
    var tags: [String] = []
    var metacritics: [Int] = []
    var ordering: String = ""
}
