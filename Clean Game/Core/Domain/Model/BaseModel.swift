//
//  BaseModel.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

struct BaseModel<T> {
    var count: Int
    var next: String
    var previous: String
    var result: [T]
}
