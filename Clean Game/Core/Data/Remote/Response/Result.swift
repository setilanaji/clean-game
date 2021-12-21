//
//  Result.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation

enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
