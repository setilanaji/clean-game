//
//  HomePresenter.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//  
//

import Foundation

class HomePresenter: ViewToPresenterHomeProtocol {
    
    // MARK: Properties
    var view: PresenterToViewHomeProtocol?
    var interactor: PresenterToInteractorHomeProtocol?
    var router: PresenterToRouterHomeProtocol?
    
    func viewDidLoad() {
        self.getGames(in: 1)
    }
    
    func getGames(in page: Int) {
        self.interactor?.getPopularGames(in: page)
    }
    
    func getLastestGames(in page: Int) {
        self.interactor?.getLastestGames(in: page)
    }
    
    func tapGame(with id: Int) {
        router?.toDetail(with: id, on: view!)
    }
    
    func addToFavorite(with game: GameModel) {
        self.interactor?.addToFavorite(with: game)
    }
    
    func removeFromFavorite(with game: GameModel) {
        self.interactor?.removeFromFavorite(with: game)
    }
    
    func toProfile() {
        self.router?.toProfile(on: view!)
    }
}

extension HomePresenter: InteractorToPresenterHomeProtocol {
    
    func addToFavoriteSuccess(result: (Bool, String)) {
        view?.onAddToFavoriteSuccess(name: result.1)
    }
    
    func addToFavoriteFailure(error: APIError) {
        view?.onAddToFavoriteFailure(error: error.localizedDescription)
    }
    
    func removeFromFavoriteSuccess(result: (Bool, String)) {
        view?.onRemoveFromFavoriteSuccess(name: result.1)
    }
    
    func removeFromFavoriteFailure(error: APIError) {
        view?.onRemoveFromFavoriteFailure(error: error.localizedDescription)
    }
    
    func getLastestGamesSuccess(result: BaseModel<GameModel>) {
        view?.onGetLastestGamesSuccess(data: result.result)
    }
    
    func getLastestGamesFailure(error: APIError) {
        view?.onGeLastestGamesFailure(error: error.localizedDescription)
    }
    
    func getPopularGamesSuccess(result: BaseModel<GameModel>) {
        view?.onGetGamesSuccess(data: result.result)
    }
    
    func getPopularGamesFailure(error: APIError) {
        view?.onGetGamesFailure(error: error.localizedDescription)
    }
    
}
