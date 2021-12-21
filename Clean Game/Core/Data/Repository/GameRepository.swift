//
//  GameRepository.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/9.
//

import Foundation
import RxSwift

protocol GameRepositoryProtocol {
    func getGames(
        in page: Int,
        request: GameRequest
    ) -> Observable<BaseModel<GameModel>>
    
    func getGenres(
        in page: Int
    ) -> Observable<BaseModel<GenreModel>>
    
    func getGameDetail(
        with id: Int
    ) -> Observable<GameModel>
    
    func getGameScreenshots(
        with id: Int
    ) -> Observable<BaseModel<ScreenshotModel>>
    
    func addFavoriteGame(
        with game: GameModel
    ) -> Observable<(Bool, String)>
    
    func removeFavoriteGame(
        with game: GameModel
    ) -> Observable<(Bool, String)>
    
    func getFavorites() -> Observable<[GameModel]>
    
    func getSellingStores(
        with id: Int
    ) -> Observable<BaseModel<SellingStoreModel>>
}

final class GameRepository: NSObject {
    
    typealias GameInstance = (RemoteDataSource, LocaleDataSource) -> GameRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let locale: LocaleDataSource
    
    private init(remote: RemoteDataSource, locale: LocaleDataSource) {
        self.remote = remote
        self.locale = locale
    }
    
    static let shared: GameInstance = { (remoteRepo, localeRepo) in
        return GameRepository(remote: remoteRepo, locale: localeRepo)
    }
}

extension GameRepository: GameRepositoryProtocol {
    
    func getGames(
        in page: Int,
        request: GameRequest
    ) -> Observable<BaseModel<GameModel>> {
        return self.locale.getFavorites()
            .flatMap { local -> Observable<BaseModel<GameModel>> in
                let favorites = GameMapper.mapFavoriteEntitiesToDomains(input: local)
                return self.remote
                    .getGames(
                        in: page,
                        request: request
                    ).map { result -> BaseModel<GameModel> in
                        var newList = [GameModel]()
                        let list = GameMapper.mapGameResponsesToDomains(input: result.result)
                        if favorites.isEmpty {
                            let baseModel = BaseMapper.mapBaseResponseToDomain(input: result, data: list)
                            return baseModel
                        } else {
                            list.forEach { (rem) in
                                var new = rem
                                new.isFavorite = favorites.contains(where: { $0.id == rem.id })
                                newList.append(new)
                            }
                            let baseModel = BaseMapper.mapBaseResponseToDomain(input: result, data: newList)
                            return baseModel
                        }
                    }
            }
    }
    
    func getGenres(in page: Int) -> Observable<BaseModel<GenreModel>> {
        return self.remote.getGenres(in: page)
            .map { result in
                let list = GenreMapper.mapGenreResponsesToDomains(input: result.result)
                let baseModel = BaseMapper.mapBaseResponseToDomain(input: result,  data: list)
                return baseModel
            }
    }
    
    func getGameDetail(with id: Int) -> Observable<GameModel> {
        return self.remote.getGameDetail(with: id)
            .flatMap { result -> Observable<GameModel> in
                return self.locale.getFavorite(with: id).map { local -> GameModel in
                    var game = GameMapper.mapGameResponseToDomain(input: result)
                    game.isFavorite = local != nil
                    return game
                }
            }
    }
    
    func getGameScreenshots(with id: Int) -> Observable<BaseModel<ScreenshotModel>> {
        return self.remote.getGameScreenshots(with: id)
            .map { result in
                let list = GameMapper.mapScreenshotResponsesToDomains(input: result.result)
                return BaseMapper.mapBaseResponseToDomain(input: result, data: list)
            }
    }
    
    func addFavoriteGame(with game: GameModel) -> Observable<(Bool, String)> {
        return self.locale.addFavoriteGame(from: GameMapper.mapGameDomainToEntity(input: game))
    }
    
    func removeFavoriteGame(with game: GameModel) -> Observable<(Bool, String)> {
        return self.locale.removeFavoriteGame(from: GameMapper.mapGameDomainToEntity(input: game))
    }
    
    func getFavorites() -> Observable<[GameModel]> {
        return self.locale.getFavorites().map { GameMapper.mapFavoriteEntitiesToDomains(input: $0) }
    }
    
    func getSellingStores(with id: Int) -> Observable<BaseModel<SellingStoreModel>> {
        return self.remote.getSellingStores(with: id)
            .map { result in
                let list = StoreMapper.mapSellingStoreResponsesToDomain(input: result.result)
                return BaseMapper.mapBaseResponseToDomain(input: result, data: list)
            }
    }
}
