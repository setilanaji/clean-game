//
//  FavoriteEntity.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/28.
//

import Foundation
import RealmSwift

class FavoriteEntity: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var released: String = ""
    @objc dynamic var rating: Float = 0
    @objc dynamic var ratingsCount: Int = 0
    @objc dynamic var backgroundImage: String = ""
    @objc dynamic var gameDescription: String = ""
    @objc dynamic var website: String = ""
    @objc dynamic var reviewsCount: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
