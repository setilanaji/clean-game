//
//  StoreModel.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/5.
//

import UIKit

struct BaseStoreModel {
    var id: Int
    var url: String
    var store: StoreModel
}

struct StoreModel {
    var id: Int
    var name: String
    var slug: String
    var domain: String
}
