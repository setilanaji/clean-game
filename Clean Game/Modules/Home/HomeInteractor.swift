//
//  HomeInteractor.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation
import RxSwift

class HomeInteractor: PresenterToInteractorHomeProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterHomeProtocol?
    private let repository: GameRepositoryProtocol
    private var disposeBag = DisposeBag()
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPopularGames(in page: Int) {
        repository
            .getGames(
                in: page,
                request: GameRequest(genres: [], tags: [], metacritics: [], ordering: "-metacritic")
            )
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                print("call \(result)")
                self.presenter?.getPopularGamesSuccess(result: result)
            } onError: { error in
                print("call \(error.localizedDescription)")
                self.presenter?.getPopularGamesFailure(error: error as? APIError ?? .requestFailed(message: ""))
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
    
    func getLastestGames(in page: Int) {
        repository
            .getGames(
                in: page,
                request: GameRequest(genres: [], tags: [], metacritics: [], ordering: "released")
            )
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.getLastestGamesSuccess(result: result)
            } onError: { error in
                self.presenter?.getLastestGamesFailure(error: error as? APIError ?? APIError.requestFailed(message: ""))
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
    
    func addToFavorite(with game: GameModel) {
        repository.addFavoriteGame(with: game)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.addToFavoriteSuccess(result: result)
            } onError: { error in
                self.presenter?.addToFavoriteFailure(error: error as? APIError ?? APIError.requestFailed(message: ""))
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
    
    func removeFromFavorite(with game: GameModel) {
        repository.removeFavoriteGame(with: game)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.presenter?.removeFromFavoriteSuccess(result: result)
            } onError: { error in
                self.presenter?.removeFromFavoriteFailure(error: error as? APIError ?? APIError.requestFailed(message: ""))
            } onCompleted: {
                
            } .disposed(by: disposeBag)
    }
}
