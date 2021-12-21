//
//  LocaleDataSource.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/28.
//

import Foundation
import RealmSwift
import RxSwift

protocol LocaleDataSourceProtocol: AnyObject {
    func removeFavoriteGame(
        from favorite: FavoriteEntity
    ) -> Observable<(Bool, String)>
    
    func addFavoriteGame(
        from favorite: FavoriteEntity
    ) -> Observable<(Bool, String)>
    
    func getFavorites() -> Observable<[FavoriteEntity]>
    
    func getFavorite(
        with id: Int
    ) -> Observable<FavoriteEntity?>
}

final class LocaleDataSource: NSObject {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let shared: (Realm?) -> LocaleDataSource = { realmDatabase in
        return LocaleDataSource(realm: realmDatabase)
    }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
    func getFavorite(
        with id: Int
    ) -> Observable<FavoriteEntity?> {
        return Observable<FavoriteEntity?>.create { observer in
            if let realm = self.realm {
                let result = realm.objects(FavoriteEntity.self).filter("id = %@", String(id)).first
                if let objsect = result {
                    observer.onNext(objsect)
                    observer.onCompleted()
                } else {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func addFavoriteGame(
        from favorite: FavoriteEntity
    ) -> Observable<(Bool, String)> {
        return Observable<(Bool, String)>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(favorite)
                        observer.onNext((true, favorite.name))
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func removeFavoriteGame(
        from favorite: FavoriteEntity
    ) -> Observable<(Bool, String)> {
        return Observable<(Bool, String)>.create { observer in
            if let realm = self.realm {
                do {
                    let result = realm.objects(FavoriteEntity.self).filter("id = %@", favorite.id ).first
                    try realm.write {
                        if let object = result {
                            realm.delete(object)
                            observer.onNext((true, favorite.name))
                            observer.onCompleted()
                        } else {
                            observer.onNext((false, favorite.name))
                            observer.onCompleted()
                        }
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func getFavorites() -> Observable<[FavoriteEntity]> {
        return Observable<[FavoriteEntity]>.create {  observer in
            if let realm = self.realm {
              let favorites: Results<FavoriteEntity> = {
                realm.objects(FavoriteEntity.self)
                  .sorted(byKeyPath: "name", ascending: true)
              }()
                observer.onNext(favorites.toArray(ofType: FavoriteEntity.self))
                observer.onCompleted()
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }

    }
}

extension Results {

  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }

}
