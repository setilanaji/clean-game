//
//  RemoteDataSource.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/8.
//

import Foundation
import RxSwift

protocol RemoteDataSourceProtocol: AnyObject {
    
    func getGames(
        in page: Int,
        request: GameRequest
    ) -> Observable<BaseResponse<GameResponse>>
    
    func getGenres(
        in page: Int
    ) -> Observable<BaseResponse<GenreReponse>>
    
    func getPlatforms(
        in page: Int
    ) -> Observable<BaseResponse<PlatformResponse>>
    
    func getGameDetail(
        with id: Int
    ) -> Observable<GameResponse>
    
    func getGameScreenshots(
        with id: Int
    ) -> Observable<BaseResponse<ScreenshotResponse>>
    
    func getSellingStores(
        with id: Int
    ) -> Observable<BaseResponse<SellingStoreResponse>>
}

final class RemoteDataSource: NSObject {
    
    typealias RemoteDataSourceInstance = (RemoteManager) -> RemoteDataSource
    
    fileprivate let manager: RemoteManager
    
    private init(manager: RemoteManager) {
        self.manager = manager
    }
    
    static let shared: RemoteDataSourceInstance = { remoteManager in
        return RemoteDataSource(manager: remoteManager)
    }
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    
    func getGames(
        in page: Int,
        request: GameRequest
    ) -> Observable<BaseResponse<GameResponse>> {
        return self.manager.callBase(type: Endpoints.getGamesIn(page: page, request: request))
    }
    
    func getGenres(in page: Int) -> Observable<BaseResponse<GenreReponse>> {
        return self.manager.callBase(type: Endpoints.getGenres(page: page))
    }
    
    func getPlatforms(in page: Int) -> Observable<BaseResponse<PlatformResponse>> {
        return self.manager.callBase(type: Endpoints.getPlatforms(page: page))
    }
    
    func getGameDetail(with id: Int) -> Observable<GameResponse> {
        return self.manager.call(type: Endpoints.getGameDetailWith(id: id))
    }
    
    func getGameScreenshots(with id: Int) -> Observable<BaseResponse<ScreenshotResponse>> {
        return self.manager.call(type: Endpoints.getScreenshotsWith(id: id))
    }
    
    func getSellingStores(with id: Int) -> Observable<BaseResponse<SellingStoreResponse>> {
        return self.manager.call(type: Endpoints.getSellingStores(id: id))
    }
    
}
